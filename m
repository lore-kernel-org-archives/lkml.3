Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756828AbaGJAyW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 20:54:22 -0400
Received: from mail-ie0-f175.google.com ([209.85.223.175]:58611 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753574AbaGJAyV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 20:54:21 -0400
MIME-Version: 1.0
In-Reply-To: <20140709190419.GA14346@kroah.com>
References: <1404234313-21634-1-git-send-email-navin.patidar@gmail.com>
	<20140709190419.GA14346@kroah.com>
Date: Thu, 10 Jul 2014 06:24:21 +0530
Message-ID: <CAPV97yeBsA3A9m=troMHgqUcG2=idCKUWh4sPS+ob0w8VGC76g@mail.gmail.com>
Subject: Re: [PATCH 1/5] staging: rtl8188eu: Remove WEXT_PRIV private ioctl handlers
From: navin patidar <navin.patidar@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Larry Finger <Larry.Finger@lwfinger.net>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 10, 2014 at 12:34 AM, Greg KH <gregkh@linuxfoundation.org> wrote:
> On Tue, Jul 01, 2014 at 10:35:09PM +0530, navin patidar wrote:
>> Remove WEXT_PRIV (non-standard) ioctl handlers.
>>
>> Signed-off-by: navin patidar <navin.patidar@gmail.com>
>> ---
>>  drivers/staging/rtl8188eu/os_dep/ioctl_linux.c | 6335 +++---------------------
>>  1 file changed, 744 insertions(+), 5591 deletions(-)
>
> This patch fails to apply :(
>
> Can you refresh it, and resend this series?

Please apply following patches.

[PATCH v2 1/3] staging: rtl8188eu: re-use mac_pton() helper
[PATCH v2 2/3] staging: rtl8188eu: substitute custom hex2bin()
[PATCH v2 3/3] staging: rtl8188eu: re-use hex_to_bin() instead of custom code

Then try again to apply my patches.

regards,
navin patidar
