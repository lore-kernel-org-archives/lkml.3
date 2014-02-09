Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752157AbaBIRFL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 12:05:11 -0500
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:3019 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751438AbaBIRFJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 12:05:09 -0500
Message-ID: <52F7B522.1000205@xs4all.nl>
Date: Sun, 09 Feb 2014 18:04:34 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131103 Icedove/17.0.10
MIME-Version: 1.0
To: Paul Bolle <pebolle@tiscali.nl>
CC: Mauro Carvalho Chehab <m.chehab@samsung.com>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [media] si4713: Remove "select SI4713"
References: <1391957777.25424.15.camel@x220> <52F79C37.5030000@xs4all.nl> <1391959624.25424.29.camel@x220>
In-Reply-To: <1391959624.25424.29.camel@x220>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/09/2014 04:27 PM, Paul Bolle wrote:
> Hans,
> 
> On Sun, 2014-02-09 at 16:18 +0100, Hans Verkuil wrote:
>> USB_SI4713 and PLATFORM_SI4713 both depend on I2C_SI4713. So the select
>> should be I2C_SI4713.
> 
> Are you sure? I've actually scanned si4713.c before submitting this
> patch and I couldn't find anything in it that these other two modules
> require. Have I overlooked anything?

The i2c module is loaded by v4l2_i2c_new_subdev_board().

Regards,

	Hans

> 
>>  If you can post a patch fixing that, then I'll pick
>> it up for 3.14.
>>
>> With the addition of the USB si4713 driver things moved around and were
>> renamed, and these selects were missed.
> 
> Thanks,
> 
> 
> Paul Bolle
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

