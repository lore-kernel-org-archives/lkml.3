Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755541Ab3LELJD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 06:09:03 -0500
Received: from mail-ee0-f52.google.com ([74.125.83.52]:46377 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755045Ab3LELI6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 06:08:58 -0500
From: Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCH v3 1/3] Documentation: arm: add UEFI support documentation
To: Matt Sealey <neko@bakuhatsu.net>, Leif Lindholm <leif.lindholm@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-efi@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>, matt.fleming@intel.com,
        Roy Franz <roy.franz@linaro.org>, Mark Salter <msalter@redhat.com>,
        Patch Tracking <patches@linaro.org>, linaro-uefi@lists.linaro.org,
        Mark Rutland <mark.rutland@arm.com>, Rob Landley <rob@landley.net>,
        linux-doc@vger.kernel.org
In-Reply-To: <CAHCPf3tsWdV+dJGm6mX6N4Ou5EQoGukdLyRvsRX6VQFjtKgxtg@mail.gmail.com>
References: <1385656883-4420-1-git-send-email-leif.lindholm@linaro.org> < 1385656883-4420-2-git-send-email-leif.lindholm@linaro.org> < CAHCPf3t5dEzVWbYZ6DWcFCENNO2dbrx-YeZvKRk0MkEsJMTE3A@mail.gmail.com> < 20131202210719.GQ24997@rocoto.smurfnet.nu> < CAHCPf3tsWdV+dJGm6mX6N4Ou5EQoGukdLyRvsRX6VQFjtKgxtg@mail.gmail.com>
Date: Thu, 05 Dec 2013 11:08:48 +0000
Message-Id: <20131205110848.A9385C40710@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Dec 2013 15:06:47 -0600, Matt Sealey <neko@bakuhatsu.net> wrote:
> If your platform has UEFI, then your platform has UEFI - if you built
> a multiplatform kernel that needs to boot on U-Boot, then you glued an
> EFI stub to it to make it boot. At some point between the stub and the
> runtime services driver, you're going through 10,000 lines of code
> with the information that it *is* running on top of UEFI completely
> lost to the boot process.
> 
> I believe I am also objecting to the idea that the way this is BEST
> implemented is to take a stock zImage (decompressor+Image payload) and
> glue a stub in front to resolve the interface issue when the
> implication is extra complication to the boot process.

Adding UEFI support to an existing image type was a design goal when we
started. Having yet another image format which is not compatibile with
existing firmware adds yet another barrier to migrating from U-Boot to
UEFI, or to supporting multiplatforms.

g.
