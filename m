Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754258Ab3JaNMr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 09:12:47 -0400
Received: from merlin.infradead.org ([205.233.59.134]:42252 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753508Ab3JaNMq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 09:12:46 -0400
Date: Thu, 31 Oct 2013 14:12:28 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Mark Wielaard <mjw@redhat.com>, Pekka Enberg <penberg@iki.fi>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Pekka Enberg <penberg@kernel.org>,
        Hemant Kumar <hkshaw@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Oleg Nesterov <oleg@redhat.com>, hegdevasant@linux.vnet.ibm.com,
        Ingo Molnar <mingo@redhat.com>, anton@redhat.com,
        systemtap@sourceware.org, Namhyung Kim <namhyung@kernel.org>,
        aravinda@linux.vnet.ibm.com, dsahern@gmail.com,
        "yrl.pp-manager.tt@hitachi.com" <yrl.pp-manager.tt@hitachi.com>
Subject: Re: [PATCH v4 2/3] Support for perf to probe into SDT markers:
Message-ID: <20131031131228.GV19466@laptop.lan>
References: <20131023044511.1886.82571.stgit@hemant-fedora>
 <20131023050502.1886.15779.stgit@hemant-fedora>
 <CAOJsxLFKm3TxeTmGjbpr1r4sZ8fHcM481-5BM_Cq0J8hhtvBqQ@mail.gmail.com>
 <y0mbo2cs2oa.fsf@fche.csb>
 <5270D9F7.3090105@hitachi.com>
 <5270F2DE.6040505@iki.fi>
 <1383216886.6521.5910.camel@bordewijk.wildebeest.org>
 <20131031105759.GB12066@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131031105759.GB12066@gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 31, 2013 at 11:57:59AM +0100, Ingo Molnar wrote:
> I suppose those Java libraries ought to show up in 
> /etc/prelink.cache though, right?

I just checked, none of my systems have prelinking enabled by default;
so its not something you can rely on.

ISTR prelinking defeated ASLR and thus was very short lived.
