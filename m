Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752265Ab3DUVrt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Apr 2013 17:47:49 -0400
Received: from mail.skyhub.de ([78.46.96.112]:48314 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751919Ab3DUVrs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Apr 2013 17:47:48 -0400
Date: Sun, 21 Apr 2013 23:47:44 +0200
From: Borislav Petkov <bp@alien8.de>
To: Jake <client.alive@gmx.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 3.6.11  AMD-Vi: Completion-Wait loop timed out
Message-ID: <20130421214744.GA6977@pd.tnic>
References: <50FBC7EF.6040207@xs4all.nl>
 <20130120103652.GB16800@pd.tnic>
 <50FBC994.8020409@xs4all.nl>
 <20130120111920.GL25591@8bytes.org>
 <50FBD413.1000406@xs4all.nl>
 <20130120114011.GN25591@8bytes.org>
 <20130120114828.GB16519@pd.tnic>
 <20130120115755.GO25591@8bytes.org>
 <20130121130942.GB4445@pd.tnic>
 <loom.20130421T025332-280@post.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <loom.20130421T025332-280@post.gmane.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 21, 2013 at 01:03:16AM +0000, Jake wrote:
> ACPI BIOS Bug: Warning: Optional FADT field Pm2CintrolBlock has no address or length: 0x0000000000000000/0x1 (20121018/tbfadt-589)

I have the same one:

[    0.000000] ACPI BIOS Bug: Warning: Optional FADT field Pm2ControlBlock has zero address or length: 0x0000000000000000/0x1 (20130117/tbfadt-599)

We probably have the same ASUS crap for a board.

> I have no idea whether this is related to my shutdown problem or not and

I don't think so as I can suspend/resume/shutdown my box just fine. :)

> what I was hoping is if someone would advise me how to find help for
> my problem. I have tried all the normal routes for my distro (forum
> and irc) repeatedly, and googled my weeping eyes out - but to no
> avail.

Have you tried the upstream kernel yet? I hear 3.9-rc8 will be out
tomorrow :-)

HTH.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
