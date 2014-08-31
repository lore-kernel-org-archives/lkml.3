Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751254AbaHaHZH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2014 03:25:07 -0400
Received: from mail-ig0-f179.google.com ([209.85.213.179]:35565 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751204AbaHaHZE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2014 03:25:04 -0400
MIME-Version: 1.0
In-Reply-To: <20140830204454.GA22900@kroah.com>
References: <1408803521-13715-1-git-send-email-navin.patidar@gmail.com>
	<1408803521-13715-3-git-send-email-navin.patidar@gmail.com>
	<20140830204454.GA22900@kroah.com>
Date: Sun, 31 Aug 2014 12:55:02 +0530
Message-ID: <CAPV97ydaPkQVxOE3XYpgxEYO8v0qJEQwhNVmGz-uv7kGaJpaOg@mail.gmail.com>
Subject: Re: [PATCH 03/20] staging: rtl8188eu: Rework function PHY_QueryBBReg()
From: navin patidar <navin.patidar@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 31, 2014 at 2:14 AM, Greg KH <gregkh@linuxfoundation.org> wrote:
> On Sat, Aug 23, 2014 at 07:48:24PM +0530, navin patidar wrote:
>> Rename CamelCase variables and function name.
>>
>> Signed-off-by: navin patidar <navin.patidar@gmail.com>
>
> This patch fails to apply:
>
> checking file drivers/staging/rtl8188eu/hal/HalHWImg8188E_RF.c
> checking file drivers/staging/rtl8188eu/hal/HalPhyRf_8188e.c
> checking file drivers/staging/rtl8188eu/hal/odm.c
> checking file drivers/staging/rtl8188eu/hal/odm_RTL8188E.c
> checking file drivers/staging/rtl8188eu/hal/rtl8188e_phycfg.c
> checking file drivers/staging/rtl8188eu/hal/usb_halinit.c
> checking file drivers/staging/rtl8188eu/include/Hal8188EPhyCfg.h
> checking file drivers/staging/rtl8188eu/include/phy.h
> Hunk #1 FAILED at 1.
> 1 out of 1 hunk FAILED
>
> Can you please refresh it against my staging-next branch of the
> staging.git tree on git.kernel.org and resend it, and the rest of the
> patches in this series so that I can apply them?

I've sent v2 of the rest of the patches in this series.

regards,
--navin-patidar
