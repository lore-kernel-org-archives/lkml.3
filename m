Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752332AbaKKWse (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 17:48:34 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50310 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751933AbaKKWsd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 17:48:33 -0500
Date: Tue, 11 Nov 2014 16:48:25 -0600
From: Seth Jennings <sjenning@redhat.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Petr Mladek <pmladek@suse.cz>, Josh Poimboeuf <jpoimboe@redhat.com>,
        Vojtech Pavlik <vojtech@suse.cz>, Steven Rostedt <rostedt@goodmis.org>,
        live-patching@vger.kernel.org, kpatch@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: module notifier: was Re: [PATCH 2/2] kernel: add support for
 live patching
Message-ID: <20141111224825.GB9066@cerebellum.variantweb.net>
References: <1415284748-14648-1-git-send-email-sjenning@redhat.com>
 <1415284748-14648-3-git-send-email-sjenning@redhat.com>
 <20141107171307.GC1136@dhcp128.suse.cz>
 <20141107180711.GC2057@cerebellum.variantweb.net>
 <20141107184011.GF1136@dhcp128.suse.cz>
 <20141111194008.GA9066@cerebellum.variantweb.net>
 <alpine.LNX.2.00.1411112315180.4454@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1411112315180.4454@pobox.suse.cz>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 11, 2014 at 11:17:39PM +0100, Jiri Kosina wrote:
> On Tue, 11 Nov 2014, Seth Jennings wrote:
> 
> > It will be in v2 (hopefully out in the next couple of days).
> 
> FWIW we are also working on a few patches on top of v1 to back some of the 
> proposals we've made during the first round of review, so maybe it might 
> make sense to wait with v2 a little bit more, so that it incorporates as 
> much v1 feedback as possible ... ?

What proposals in particular?  I've already made many of the changes
that we agreed upon.

Thanks,
Seth

> 
> Thanks,
> 
> -- 
> Jiri Kosina
> SUSE Labs
