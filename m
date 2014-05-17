Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750822AbaEQSoB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2014 14:44:01 -0400
Received: from mail-we0-f170.google.com ([74.125.82.170]:36073 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964844AbaEQSny (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2014 14:43:54 -0400
Message-ID: <5377ADE5.1030304@gmail.com>
Date: Sat, 17 May 2014 20:43:49 +0200
From: Gianluca Gennari <gennarone@gmail.com>
Reply-To: gennarone@gmail.com
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Martin Kepplinger <martink@posteo.de>, Antti Palosaari <crope@iki.fi>,
        gregkh@linuxfoundation.org,
        Devin Heitmueller <dheitmueller@kernellabs.com>
CC: m.chehab@samsung.com, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2] staging: media: as102: replace custom dprintk() with
 dev_dbg()
References: <53776B57.5050504@iki.fi> <1400342738-32652-1-git-send-email-martink@posteo.de> <53779A7F.8020007@iki.fi> <5377A1CC.7020104@posteo.de>
In-Reply-To: <5377A1CC.7020104@posteo.de>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 17/05/2014 19:52, Martin Kepplinger ha scritto:
> Am 2014-05-17 19:21, schrieb Antti Palosaari:
>> On 05/17/2014 07:05 PM, Martin Kepplinger wrote:
>>> don't reinvent dev_dbg(). remove dprintk() in as102_drv.c.
>>> use the common kernel coding style.
>>>
>>> Signed-off-by: Martin Kepplinger <martink@posteo.de>
>>
>> Reviewed-by: Antti Palosaari <crope@iki.fi>
>>
>>> ---
>>> this applies to next-20140516. any more suggestions?
>>> more cleanup can be done when dprintk() is completely gone.
>>
>> Do you have the device? I am a bit reluctant patching that driver
>> without any testing as it has happened too many times something has gone
>> totally broken.
> I don't have the device and will, at most, change such style issues.
> 
>>
>> IIRC Devin said it is in staging because of style issues and nothing
>> more. Is that correct?
> I haven't heard anything. A TODO file would help.

Hi Antti, Martin,
if I remember correctly, the main issue with this driver is that the
device does not work anymore after a reboot: it needs a power cycle to
start working again. Probably this issue is enough to keep the driver in
staging.

Regards,
Gianluca

> 
>>
>> regards
>> Antti
>>
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

