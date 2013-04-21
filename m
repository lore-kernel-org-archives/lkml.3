Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751067Ab3DUBKK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Apr 2013 21:10:10 -0400
Received: from plane.gmane.org ([80.91.229.3]:36976 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750872Ab3DUBKI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Apr 2013 21:10:08 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Jake <client.alive@gmx.com>
Subject: Re: 3.6.11  AMD-Vi: Completion-Wait loop timed out
Date: Sun, 21 Apr 2013 01:03:16 +0000 (UTC)
Message-ID: <loom.20130421T025332-280@post.gmane.org>
References: <50FBC7EF.6040207@xs4all.nl> <20130120103652.GB16800@pd.tnic> <50FBC994.8020409@xs4all.nl> <20130120111920.GL25591@8bytes.org> <50FBD413.1000406@xs4all.nl> <20130120114011.GN25591@8bytes.org> <20130120114828.GB16519@pd.tnic> <20130120115755.GO25591@8bytes.org> <20130121130942.GB4445@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: sea.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 96.2.68.58 (Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:20.0) Gecko/20100101 Firefox/20.0)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Borislav Petkov <bp <at> alien8.de> writes:

> 
> On Sun, Jan 20, 2013 at 12:57:55PM +0100, Jörg Rödel wrote:
> > BorisO is no longer with AMD afaik.
> 
> Why am I not surprised...
> 
> > I wrote an email to Sherry and Suravee and asked them to either send
> > me hardware to write the fix on my own or to send a fix for the issue.
> > Let's see what happens...
> 
> Btw, while we're at it, here's some more h0rkage from my PD box:
> 
> [    0.220022] [Firmware Bug]: AMD-Vi: IOAPIC[9] not in IVRS table
> [    0.220078] [Firmware Bug]: AMD-Vi: IOAPIC[10] not in IVRS table
> [    0.220132] [Firmware Bug]: AMD-Vi: No southbridge IOAPIC found in IVRS
table
> [    0.220187] AMD-Vi: Disabling interrupt remapping due to BIOS Bug(s)
> 

hello,

I've never posted to this type of message board before so I hope I'm not out
of order. I found my way here while trying to solve a shutdown problem in a
new linux install (Arch). I've noticed for some time that I have the same
lines as above in my dmesg as well as: 

ACPI BIOS Bug: Warning: Optional FADT field Pm2CintrolBlock has no address
or length: 0x0000000000000000/0x1 (20121018/tbfadt-589)

I have no idea whether this is related to my shutdown problem or not and
what I was hoping is if someone would advise me how to find help for my
problem. I have tried all the normal routes for my distro (forum and irc)
repeatedly, and googled my weeping eyes out - but to no avail.

Any advice would be greatly appreciated.

Thanks
Jake



