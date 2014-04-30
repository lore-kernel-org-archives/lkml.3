Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755878AbaD3Hwc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 03:52:32 -0400
Received: from mail-ie0-f176.google.com ([209.85.223.176]:59356 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755269AbaD3Hwa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 03:52:30 -0400
MIME-Version: 1.0
In-Reply-To: <DC148C5AA1CEBA4E87973D432B1C2D8825E24280@P3PWEX4MB008.ex4.secureserver.net>
References: <1398562711-6313-1-git-send-email-chase.southwood@gmail.com>
	<1398760700-19397-1-git-send-email-chase.southwood@gmail.com>
	<DC148C5AA1CEBA4E87973D432B1C2D8825E24280@P3PWEX4MB008.ex4.secureserver.net>
Date: Wed, 30 Apr 2014 02:52:28 -0500
Message-ID: <CA+jnaaV7YDQYAGg_yksfiD31bCGN0brvZvBqi0VrK6hV_moxzA@mail.gmail.com>
Subject: Re: [PATCH 6/6 v2] staging: comedi: addi_apci_1564: remove use of devpriv->s_EeParameters
From: Chase Southwood <chase.southwood@gmail.com>
To: Hartley Sweeten <HartleyS@visionengravers.com>
Cc: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "abbotti@mev.co.uk" <abbotti@mev.co.uk>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ian and Hartley,

Thanks so much, I greatly appreciate the review.  I'll fix the
changelog for patch 4 and send once more (as I assume that's easier
for Greg).  Also, I should know better about the cover letter as
well...I was once told not to send them for strictly cleanup patchsets
(as Greg can't do anything with them and cleanups should be obvious)
but I've gotten in the habit of not doing a cover letter for any
patchsets.  I will send cover letters (and be more careful about my
other mistakes) in the future.

Thanks,
Chase

On Tue, Apr 29, 2014 at 3:33 PM, Hartley Sweeten
<HartleyS@visionengravers.com> wrote:
> On, Tuesday, April 29, 2014 1:38 AM, Chase Southwood wrote:
>> This driver no longer reads the eeprom to find the board specific data,
>> all the necessary data is in the boardinfo. Use the boardinfo directly
>> instead of passing through devpriv->s_EeParameters.
>>
>> Signed-off-by: Chase Southwood <chase.southwood@gmail.com>
>> Cc: Ian Abbott <abbotti@mev.co.uk>
>> Cc: H Hartley Sweeten <hsweeten@visionengravers.com>
>> ---
>> 2: Incorrect patch title fixed.
>>
>> Ian and Hartley,
>>
>> The auto_attach() function is starting to look much better now.  My next patchset
>> will be geared towards only allocating subdevices which are actually used.
>
> Other than Ian's comment on patch 4/6 everything looks good to me.
>
> For the series:
> Reviewed-by: H Hartley Sweeten <hsweeten@visionengravers.com>
>
> BTW, for a patch series you should include a cover letter (PATCH 00/xx).
>
> Regards,
> Hartley
