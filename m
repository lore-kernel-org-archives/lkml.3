Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755586Ab3DDE3g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 00:29:36 -0400
Received: from server.prisktech.co.nz ([115.188.14.127]:64944 "EHLO
	server.prisktech.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753485Ab3DDE3f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 00:29:35 -0400
Message-ID: <515D01CC.2060606@prisktech.co.nz>
Date: Thu, 04 Apr 2013 17:30:04 +1300
From: Tony Prisk <linux@prisktech.co.nz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Linus Walleij <linus.walleij@linaro.org>,
        Rob Herring <robherring2@gmail.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "vt8500-wm8505-linux-kernel@googlegroups.com" 
	<vt8500-wm8505-linux-kernel@googlegroups.com>
Subject: Re: [PATCHv5 0/7] arm: vt8500: Add support for pinctrl/gpio module
References: <1364970291-17721-1-git-send-email-linux@prisktech.co.nz> <CACRpkdZAtgpfA5rZ_C=eKDDOE9aDm=3k1QDava=EGL2BaoV+0g@mail.gmail.com> <515C9DB7.9000908@wwwdotorg.org>
In-Reply-To: <515C9DB7.9000908@wwwdotorg.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/04/13 10:23, Stephen Warren wrote:
> On 04/03/2013 07:40 AM, Linus Walleij wrote:
>> On Wed, Apr 3, 2013 at 8:24 AM, Tony Prisk <linux@prisktech.co.nz> wrote:
>>
>>> v5 changes:
>>> Changed as requested by Rob Herring:
>>> Added of_find_property_value_of_size() to drivers/of/base.c to remove some
>>> code that was being duplicated.
>>>
>>> Changed as requested by Stephen Warren:
>>> Redid the kfree(maps) code as devm_kzalloc would cause issues. We now kzalloc
>>> maps all at once, and configs as required. A call to wmt_pctl_dt_free_map() is
>>> used to kfree the allocated blocks if we fail early.
>> This v5 series:
>> Acked-by: Linus Walleij <linus.walleij@linaro.org>
>>
>> I guess it will go in through the VT8500 tree eventually?
>>
>> Maybe you could put Stephen's BCMring patch on top when sending
>> it in (also Acked-by) so we can avoid having that dangling.
> s/bcmring/bcm2835/ :-)
Stephen,

Can you just confirm you want:

pinctrl: bcm2835: make use of of_property_read_u32_index()

to be included in the pull with this series. I'll get it sent out once 
you let me know.

Regards
Tony P
