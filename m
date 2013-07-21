Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754760Ab3GUJgV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jul 2013 05:36:21 -0400
Received: from mail.skyhub.de ([78.46.96.112]:44687 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754211Ab3GUJgU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jul 2013 05:36:20 -0400
Date: Sun, 21 Jul 2013 11:36:10 +0200
From: Borislav Petkov <bp@alien8.de>
To: Alex Deucher <alexdeucher@gmail.com>
Cc: Ben Hutchings <ben@decadent.org.uk>, lkml <linux-kernel@vger.kernel.org>
Subject: radeon firmware
Message-ID: <20130721093610.GA30711@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Alex,

I keep getting people's configs with

CONFIG_EXTRA_FIRMWARE="... radeon/RV710_uvd.bin radeon/RV730_smc.bin..."

but I can't find those blobs in the k.org fw repo:

git://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git

This here http://www.x.org/wiki/radeonBuildHowTo/ says that
http://people.freedesktop.org/~agd5f/radeon_ucode/ contains them, and,
AFAICT, the license is the same. So what's the story, are those going
into the firmware-linux repo anytime soon?

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
