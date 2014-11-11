Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752283AbaKKWRl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 17:17:41 -0500
Received: from cantor2.suse.de ([195.135.220.15]:52999 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752025AbaKKWRk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 17:17:40 -0500
Date: Tue, 11 Nov 2014 23:17:39 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Seth Jennings <sjenning@redhat.com>
cc: Petr Mladek <pmladek@suse.cz>, Josh Poimboeuf <jpoimboe@redhat.com>,
        Vojtech Pavlik <vojtech@suse.cz>, Steven Rostedt <rostedt@goodmis.org>,
        live-patching@vger.kernel.org, kpatch@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: module notifier: was Re: [PATCH 2/2] kernel: add support for
 live patching
In-Reply-To: <20141111194008.GA9066@cerebellum.variantweb.net>
Message-ID: <alpine.LNX.2.00.1411112315180.4454@pobox.suse.cz>
References: <1415284748-14648-1-git-send-email-sjenning@redhat.com> <1415284748-14648-3-git-send-email-sjenning@redhat.com> <20141107171307.GC1136@dhcp128.suse.cz> <20141107180711.GC2057@cerebellum.variantweb.net> <20141107184011.GF1136@dhcp128.suse.cz>
 <20141111194008.GA9066@cerebellum.variantweb.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Nov 2014, Seth Jennings wrote:

> It will be in v2 (hopefully out in the next couple of days).

FWIW we are also working on a few patches on top of v1 to back some of the 
proposals we've made during the first round of review, so maybe it might 
make sense to wait with v2 a little bit more, so that it incorporates as 
much v1 feedback as possible ... ?

Thanks,

-- 
Jiri Kosina
SUSE Labs
