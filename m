Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933573Ab3CVIiD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 04:38:03 -0400
Received: from slimlogic.co.uk ([89.16.172.20]:39182 "EHLO slimlogic.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753930Ab3CVIiA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 04:38:00 -0400
Message-ID: <514C1865.1020602@slimlogic.co.uk>
Date: Fri, 22 Mar 2013 08:37:57 +0000
From: Ian Lartey <ian@slimlogic.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130221 Thunderbird/17.0.3
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: Laxman Dewangan <ldewangan@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        Graeme Gregory <gg@slimlogic.co.uk>
Subject: Re: [PATCH] gpio: palmas: add in GPIO support for palmas charger
References: <1361884868-27783-1-git-send-email-ian@slimlogic.co.uk> <512CBF75.9000103@nvidia.com> <512CC31D.6070602@slimlogic.co.uk> <512CC357.9040600@nvidia.com> <CACRpkdZyBB+Bqevgi7dGw+nWu245RgKNv7Cpim4YRuhYbcP1xw@mail.gmail.com>
In-Reply-To: <CACRpkdZyBB+Bqevgi7dGw+nWu245RgKNv7Cpim4YRuhYbcP1xw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22/03/13 07:55, Linus Walleij wrote:
> On Tue, Feb 26, 2013 at 3:14 PM, Laxman Dewangan <ldewangan@nvidia.com> wrote:
>
>> On Tuesday 26 February 2013 07:43 PM, Ian Lartey wrote:
>> On 26/02/13 13:58, Laxman Dewangan wrote:
>>
>> On Tuesday 26 February 2013 06:51 PM, Ian Lartey wrote:
>>
>> this patch depenfs on [PATCH] mfd: palmas: is_palmas_charger needed by
>> multiple drivers
>>
>> Palmas charger has 16 GPIOs
>> add palmas_gpio_[read|write|update] api to take account
>> second bank of GPIOs
>>
>> Signed-off-by: Ian Lartey <ian@slimlogic.co.uk>
>> Signed-off-by: Graeme Gregory <gg@slimlogic.co.uk>
>
> Is something happening in this series?
>
> I'm ignoring it for now since the last activity in the thread was
> some concerns from Laxman.
>
> Yours,
> Linus Walleij
>

Yes there's going to be an patch series update [v9] posted today.


Ian
