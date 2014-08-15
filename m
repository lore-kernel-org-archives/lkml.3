Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751547AbaHOQNA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 12:13:00 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:39393 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751005AbaHOQM7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 12:12:59 -0400
Message-ID: <53EE319A.1030304@wwwdotorg.org>
Date: Fri, 15 Aug 2014 10:13:14 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Nick Dyer <nick.dyer@itdev.co.uk>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Stephen Warren <swarren@nvidia.com>, Yufeng Shen <miletus@chromium.org>,
        Benson Leung <bleung@chromium.org>,
        Doug Anderson <dianders@chromium.org>, Olof Johansson <olof@lixom.net>,
        linux-input@vger.kernel.org, devicetree@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] Input: atmel_mxt_ts - Add keycodes array example
References: <1407372486-25881-1-git-send-email-javier.martinez@collabora.co.uk> <1407372486-25881-2-git-send-email-javier.martinez@collabora.co.uk> <53E37329.4020002@itdev.co.uk> <53E4E41D.4070703@collabora.co.uk> <53EDF6B4.7080804@collabora.co.uk> <53EE307E.8060507@itdev.co.uk>
In-Reply-To: <53EE307E.8060507@itdev.co.uk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/15/2014 10:08 AM, Nick Dyer wrote:
> On 15/08/14 13:01, Javier Martinez Canillas wrote:
>>> By passing all these keycodes the touchpad worked as expected for me and the
>>> driver did the same than the Chrome OS driver that has these keycodes hardcoded
>>> when is_tp is true.
>>>
>>>> at the protocol guide for T19.
>>>
>>> I don't have access to proper documentation and I wouldn't expect people to have
>>> access to non-public docs in order to use a Device Tree binding.
>>>
>>> That's why I wanted to document an example, so using this property could be
>>> easier for others and they shouldn't have to look at the driver in order to
>>> figure it out (and getting it wrong as you said :) )
>>>
>>> So it would be great if you could provide an example on how this is supposed to
>>> be used.
>>
>> Any comments on this? I would really appreciate if you can expand on how
>> this DT property is supposed to be used so I can re-spin the atmel support
>> patch for Peach boards.
>
> The below patch improves the documentation for the gpio-property.

That patch makes sense, and is a nice description,
Acked-by: Stephen Warren <swarren@nvidia.com>

> diff --git a/Documentation/devicetree/bindings/input/atmel,maxtouch.txt

>   Example:
>
>          touch@4b {
>

Perhaps it makes sense to add a linux,gpio-keymap property into the 
example too though; IIRC there was an earlier patch to the docs that did 
this?
