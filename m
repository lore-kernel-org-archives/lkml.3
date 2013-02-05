Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755643Ab3BEOtE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 09:49:04 -0500
Received: from nbd.name ([46.4.11.11]:47430 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754940Ab3BEOtA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 09:49:00 -0500
Message-ID: <51111B2F.5070803@openwrt.org>
Date: Tue, 05 Feb 2013 15:46:07 +0100
From: John Crispin <blogic@openwrt.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.7) Gecko/20120922 Icedove/10.0.7
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 04/11] PINCTRL: lantiq: add output pinconf parameter
References: <1359720305-31933-1-git-send-email-blogic@openwrt.org> <1359720305-31933-4-git-send-email-blogic@openwrt.org> <CACRpkdZf0dqJO=6wn1Q1HDPAcu0LueAYrABWLMEwO0kPHU3VbA@mail.gmail.com>
In-Reply-To: <CACRpkdZf0dqJO=6wn1Q1HDPAcu0LueAYrABWLMEwO0kPHU3VbA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/02/13 15:46, Linus Walleij wrote:
> On Fri, Feb 1, 2013 at 1:04 PM, John Crispin<blogic@openwrt.org>  wrote:
>
>> While converting the boards inside OpenWrt to OF I noticed that the we are
>> missing a pinconf parameter to set a pin to output.
>>
>> Signed-off-by: John Crispin<blogic@openwrt.org>
> OK, I have applied this, BUT:
>
>> @@ -34,6 +34,7 @@ enum ltq_pinconf_param {
>>          LTQ_PINCONF_PARAM_OPEN_DRAIN,
>>          LTQ_PINCONF_PARAM_DRIVE_CURRENT,
>>          LTQ_PINCONF_PARAM_SLEW_RATE,
>> +       LTQ_PINCONF_PARAM_OUTPUT,
>>   };
> All of this exist in the generic pinconf library nowadays.
>
> How about cooking a patch that converts the lantiq driver
> to just use that? It'll be pretty straight forward I think.
>
> I mean you convert it to use the generic pinconf internally,
> the DT representation we'll have to live with.
>
> See for example the new drivers that are boiling in
> -next. All use generic pinconf I think. The parameter to
> set a pin as output was added for the abx500 driver
> this cycle.
>
> Yours,
> Linus Walleij
>
>

Hi,

i'll look into updating the driver to the new api

     John
