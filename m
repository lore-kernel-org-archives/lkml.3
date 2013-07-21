Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755485Ab3GUNNC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jul 2013 09:13:02 -0400
Received: from mail-vc0-f182.google.com ([209.85.220.182]:51611 "EHLO
	mail-vc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755406Ab3GUNM4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jul 2013 09:12:56 -0400
MIME-Version: 1.0
In-Reply-To: <20130721093610.GA30711@pd.tnic>
References: <20130721093610.GA30711@pd.tnic>
Date: Sun, 21 Jul 2013 09:12:55 -0400
Message-ID: <CADnq5_PYtzY-fnRKbxioUcUTatCS+YvM3Cr-BxF+ZDzZ1uvnCA@mail.gmail.com>
Subject: Re: radeon firmware
From: Alex Deucher <alexdeucher@gmail.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Ben Hutchings <ben@decadent.org.uk>, lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 21, 2013 at 5:36 AM, Borislav Petkov <bp@alien8.de> wrote:
> Hey Alex,
>
> I keep getting people's configs with
>
> CONFIG_EXTRA_FIRMWARE="... radeon/RV710_uvd.bin radeon/RV730_smc.bin..."
>
> but I can't find those blobs in the k.org fw repo:
>
> git://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git
>
> This here http://www.x.org/wiki/radeonBuildHowTo/ says that
> http://people.freedesktop.org/~agd5f/radeon_ucode/ contains them, and,
> AFAICT, the license is the same. So what's the story, are those going
> into the firmware-linux repo anytime soon?

The UVD ucode is already there.  I send Ben the patches for the smc
ucode week or so ago, but I guess they haven't been applied yet.

Alex


>
> Thanks.
>
> --
> Regards/Gruss,
>     Boris.
>
> Sent from a fat crate under my desk. Formatting is fine.
> --
