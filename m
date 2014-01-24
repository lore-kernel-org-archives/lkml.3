Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751878AbaAXH0v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 02:26:51 -0500
Received: from cantor2.suse.de ([195.135.220.15]:44369 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751093AbaAXH0u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 02:26:50 -0500
Date: Fri, 24 Jan 2014 08:26:45 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Jan Kara <jack@suse.cz>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: fanotify use after free.
In-Reply-To: <20140123235549.GA7363@quack.suse.cz>
Message-ID: <alpine.LNX.2.00.1401240825470.581@pobox.suse.cz>
References: <20140122062730.GA25601@redhat.com> <CA+55aFxnv050RqhhLBbsvV4=dcu-_ZXokbhmuO8Y4zVcvVJ6OQ@mail.gmail.com> <20140122233622.GB27916@quack.suse.cz> <CA+55aFwzb7rJate=r0Sgi_N7FStNtJS_PvfgPSGaczPPgeUZvg@mail.gmail.com> <alpine.LNX.2.00.1401231120360.581@pobox.suse.cz>
 <20140123150540.GD28796@quack.suse.cz> <alpine.LNX.2.00.1401231607120.581@pobox.suse.cz> <20140123235549.GA7363@quack.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Jan 2014, Jan Kara wrote:

>   Strange. I've installed systemd system (openSUSE 13.1) and it boots 
> with the latest Linus' kernel just fine (and I have at least FANOTIFY 
> and SLAB debugging set the same way as you). But it was only a KVM 
> guest. I'll try tomorrow with a physical machine I guess.

FWIW the system I am reliably able to reproduce this on is opensuse 12.3 
with this systemd version: 

Version     : 195
Release     : 13.18.1

-- 
Jiri Kosina
SUSE Labs
