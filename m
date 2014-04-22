Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756439AbaDVOCA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 10:02:00 -0400
Received: from mail-ig0-f170.google.com ([209.85.213.170]:35168 "EHLO
	mail-ig0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756411AbaDVOBv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 10:01:51 -0400
MIME-Version: 1.0
In-Reply-To: <20140422101101.GG26890@mwanda>
References: <1397983638-10752-1-git-send-email-navin.patidar@gmail.com>
	<1397983638-10752-3-git-send-email-navin.patidar@gmail.com>
	<20140422101101.GG26890@mwanda>
Date: Tue, 22 Apr 2014 19:31:50 +0530
Message-ID: <CAPV97yd4THZOcV8CGJJ+d5otsP9pvOO5A9SgjFXLLf+sSkoN=w@mail.gmail.com>
Subject: Re: [PATCH 03/10] staging: rtl8188eu: Remove _ReadLEDSetting() function.
From: navin patidar <navin.patidar@gmail.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, Larry.Finger@lwfinger.net,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi dan

it's just a cleanup patch and i also tested all patches of this patch
series on the hardware (TP-LINK  TL-WN723N).
my mistake i should have added "Tested-by" tag for all patches.

Tested-by: navin patidar <navin.patidar@gmail.com>

regards,
--navin-patidar

On Tue, Apr 22, 2014 at 3:41 PM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
> On Sun, Apr 20, 2014 at 02:17:11PM +0530, navin patidar wrote:
>> _ReadLEDSetting() doesn't read led settings this function actually
>> initialize  member variables of struct led_priv, we should do that
>> inside rtl8188eu_InitSwLeds().
>>
>
> This seems like a bugfix or is it just a cleanup?  It's not clear to me
> from the patch description.  Have you tested this patch?
>
> regards,
> dan carpenter
>
