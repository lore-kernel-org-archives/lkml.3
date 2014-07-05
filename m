Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965239AbaGETrv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2014 15:47:51 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42613 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965069AbaGETrs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2014 15:47:48 -0400
Date: Sat, 5 Jul 2014 21:47:45 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Pavel Machek <pavel@ucw.cz>
cc: Jiri Slaby <jslaby@suse.cz>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        linux-kernel@vger.kernel.org, tj@kernel.org, rostedt@goodmis.org,
        mingo@redhat.com, akpm@linux-foundation.org, andi@firstfloor.org,
        paulmck@linux.vnet.ibm.com, jirislaby@gmail.com,
        Vojtech Pavlik <vojtech@suse.cz>, Michael Matz <matz@suse.de>,
        Udo Seidel <udoseidel@gmx.de>
Subject: Re: [PATCH -repost 05/21] kgr: update Kconfig documentation
In-Reply-To: <20140704103505.GB19252@amd.pavel.ucw.cz>
Message-ID: <alpine.LNX.2.00.1407052146280.1655@pobox.suse.cz>
References: <1403694435-3180-1-git-send-email-jslaby@suse.cz> <1403694435-3180-5-git-send-email-jslaby@suse.cz> <20140625134212.4fb38e14@alan.etchedpixels.co.uk> <53ABD8FB.9000700@suse.cz> <alpine.LNX.2.00.1406261030210.15939@pobox.suse.cz>
 <20140627191845.GA1408@xo-6d-61-c0.localdomain> <53B6708E.5030106@suse.cz> <20140704103505.GB19252@amd.pavel.ucw.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 4 Jul 2014, Pavel Machek wrote:

> > Hi, why do you believe so? But it is not so important, see below.
> 
> Because it is quite hard to prepare the patch, and there's not really
> enough documentation..? And given choice between "spend half an hour
> preparing patch" and "just reboot", people compiling their own kernels
> know what to do...

I fail to see how "having the skills to compile my own kernel" and "being 
responsible for a datacenter that can't afford immediate reboot of all 
nodes" are connected in any way.

-- 
Jiri Kosina
SUSE Labs
