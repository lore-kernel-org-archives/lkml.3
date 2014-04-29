Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754453AbaD2BgX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 21:36:23 -0400
Received: from mail-ig0-f180.google.com ([209.85.213.180]:36686 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752486AbaD2BgV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 21:36:21 -0400
MIME-Version: 1.0
In-Reply-To: <20140428092523.GS26890@mwanda>
References: <1398530635-3813-1-git-send-email-navin.patidar@gmail.com>
	<20140428092523.GS26890@mwanda>
Date: Tue, 29 Apr 2014 07:06:21 +0530
Message-ID: <CAPV97yfs_8EG2Q_inGd+jx-_v_11F0VireugD6d=Z=SvRX5juQ@mail.gmail.com>
Subject: Re: [PATCH] staging: rtl8188eu: Use USB subsystem functions to check
 endpoint type
From: navin patidar <navin.patidar@gmail.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Larry Finger <Larry.Finger@lwfinger.net>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 28, 2014 at 2:55 PM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
> On Sat, Apr 26, 2014 at 10:13:55PM +0530, navin patidar wrote:
>> Use inline functions provided by USB subsystem to check endpoint type,
>> instead of macros implemented by driver to do the same.
>>
>> Unnecessary debugging messages are also removed.
>>
>
> I like both these changes but they would have been so much easier to
> review if you deleted the debugging messagese in [patch 1/2] and then
> changed the endpoint functions in [patch 2/2].
>
>> @@ -183,60 +143,36 @@ static struct dvobj_priv *usb_dvobj_init(struct usb_interface *usb_intf)
>>       pdvobjpriv->nr_endpoint = piface_desc->bNumEndpoints;
>>
>>       for (i = 0; i < pdvobjpriv->nr_endpoint; i++) {
>> +
>
> Don't put a blank line here, btw.
>
>> +             int ep_num;
>>               phost_endp = phost_iface->endpoint + i;
>
> Anyway, please resend because it needs to be broken into two patches.

dan, I just did that.

regards,
navin patidar
