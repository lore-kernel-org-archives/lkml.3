Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756247AbaGBRlc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 13:41:32 -0400
Received: from mail-ie0-f176.google.com ([209.85.223.176]:63352 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754008AbaGBRla (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 13:41:30 -0400
MIME-Version: 1.0
In-Reply-To: <53B437D7.1050201@broadcom.com>
References: <1404234313-21634-1-git-send-email-navin.patidar@gmail.com>
	<1404234313-21634-5-git-send-email-navin.patidar@gmail.com>
	<53B437D7.1050201@broadcom.com>
Date: Wed, 2 Jul 2014 23:11:29 +0530
Message-ID: <CAPV97yeGQJQZGLuVf7tdfb3GLDyZmo_qb43BAb-LTCU_FJaDSA@mail.gmail.com>
Subject: Re: [PATCH 5/5] staging: rtl8188eu: Remove P2P support
From: navin patidar <navin.patidar@gmail.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Larry Finger <Larry.Finger@lwfinger.net>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 2, 2014 at 10:18 PM, Arend van Spriel <arend@broadcom.com> wrote:
> On 01-07-14 19:05, navin patidar wrote:
>> Signed-off-by: navin patidar <navin.patidar@gmail.com>
>
> There is probably a reason for removing this. Care to share?

I explained the reason for removing P2P support in cover letter, will
add that in v2 of this patch.
Driver is providing a non-standard wext private ioctl interface to
userspace to use P2P functionality.

> In some source files I noticed CONFIG_88EU_P2P so I sort of expected
> Kconfig in the list of files below.

thanks for pointing that out, v2 of this patch will remove
CONFIG_88EU_P2P entry from Kconfig.

thanks,
navin patidar
