Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754092Ab3JaJ7K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 05:59:10 -0400
Received: from mail-ea0-f176.google.com ([209.85.215.176]:54339 "EHLO
	mail-ea0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753954Ab3JaJ7I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 05:59:08 -0400
Date: Thu, 31 Oct 2013 10:59:02 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Pekka Enberg <penberg@iki.fi>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Pekka Enberg <penberg@kernel.org>,
        Hemant Kumar <hkshaw@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@redhat.com>,
        hegdevasant@linux.vnet.ibm.com, Ingo Molnar <mingo@redhat.com>,
        anton@redhat.com, systemtap@sourceware.org,
        Namhyung Kim <namhyung@kernel.org>, aravinda@linux.vnet.ibm.com,
        dsahern@gmail.com,
        "yrl.pp-manager.tt@hitachi.com" <yrl.pp-manager.tt@hitachi.com>
Subject: Re: [PATCH v4 2/3] Support for perf to probe into SDT markers:
Message-ID: <20131031095902.GA9971@gmail.com>
References: <20131023044511.1886.82571.stgit@hemant-fedora>
 <20131023050502.1886.15779.stgit@hemant-fedora>
 <CAOJsxLFKm3TxeTmGjbpr1r4sZ8fHcM481-5BM_Cq0J8hhtvBqQ@mail.gmail.com>
 <y0mbo2cs2oa.fsf@fche.csb>
 <5270D9F7.3090105@hitachi.com>
 <5270F2DE.6040505@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5270F2DE.6040505@iki.fi>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Pekka Enberg <penberg@iki.fi> wrote:

> On 10/30/13 12:05 PM, Masami Hiramatsu wrote:
> >To find all system libraries, we can use ldconfig.
> >
> >$ ldconfig --print-cache
> >
> >shows what dynamic libraries will be loaded. On my own laptop (running
> >ubuntu13.04) shows ~1000 libs.
> 
> Good point. That definitely narrows down the scanned set.
> 
>                         Pekka

There's also 'strings /etc/prelink.cache' that should give a good 
list of binaries and libraries that matter.

Thanks,

	Ingo
