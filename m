Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936206Ab3DRLcX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 07:32:23 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:46231
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936028Ab3DRLcW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 07:32:22 -0400
Message-ID: <1366284729.19383.16.camel@laptop>
Subject: Re: [PATCH] NMI: fix NMI period is not correct when cpu frequency
 changes issue.
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Pan, Zhenjie" <zhenjie.pan@intel.com>,
        "paulus@samba.org" <paulus@samba.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "acme@ghostprotocols.net" <acme@ghostprotocols.net>,
        "dzickus@redhat.com" <dzickus@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Liu, Chuansheng" <chuansheng.liu@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Date: Thu, 18 Apr 2013 13:32:09 +0200
In-Reply-To: <20130415163049.08498e3a8726f0bd6f4d6ebe@linux-foundation.org>
References: <F98D4B5C3D86834DB612ABF854C98B7FB54822@SHSMSX101.ccr.corp.intel.com>
	 <20130415163049.08498e3a8726f0bd6f4d6ebe@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-04-15 at 16:30 -0700, Andrew Morton wrote:
> I think this will break the build if CONFIG_PERF_EVENTS=n and
> CONFIG_LOCKUP_DETECTOR=y.  I was able to create such a config for
> powerpc.  If I'm reading it correctly, CONFIG_PERF_EVENTS cannot be
> disabled on x86_64?  If so, what the heck?

Frederic and Ingo made that happen,.. a long while ago Frederic
promised to fix that.. I suppose its never been quite important enough
to get around to :/

(Frederic; read this as a gentle prod to move his upward on the todo
list)

