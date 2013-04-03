Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763375Ab3DCVXJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 17:23:09 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:48153 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760462Ab3DCVXG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 17:23:06 -0400
Message-ID: <515C9DB7.9000908@wwwdotorg.org>
Date: Wed, 03 Apr 2013 15:23:03 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: Tony Prisk <linux@prisktech.co.nz>, Rob Herring <robherring2@gmail.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "vt8500-wm8505-linux-kernel@googlegroups.com" 
	<vt8500-wm8505-linux-kernel@googlegroups.com>
Subject: Re: [PATCHv5 0/7] arm: vt8500: Add support for pinctrl/gpio module
References: <1364970291-17721-1-git-send-email-linux@prisktech.co.nz> <CACRpkdZAtgpfA5rZ_C=eKDDOE9aDm=3k1QDava=EGL2BaoV+0g@mail.gmail.com>
In-Reply-To: <CACRpkdZAtgpfA5rZ_C=eKDDOE9aDm=3k1QDava=EGL2BaoV+0g@mail.gmail.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/03/2013 07:40 AM, Linus Walleij wrote:
> On Wed, Apr 3, 2013 at 8:24 AM, Tony Prisk <linux@prisktech.co.nz> wrote:
> 
>> v5 changes:
>> Changed as requested by Rob Herring:
>> Added of_find_property_value_of_size() to drivers/of/base.c to remove some
>> code that was being duplicated.
>>
>> Changed as requested by Stephen Warren:
>> Redid the kfree(maps) code as devm_kzalloc would cause issues. We now kzalloc
>> maps all at once, and configs as required. A call to wmt_pctl_dt_free_map() is
>> used to kfree the allocated blocks if we fail early.
> 
> This v5 series:
> Acked-by: Linus Walleij <linus.walleij@linaro.org>
> 
> I guess it will go in through the VT8500 tree eventually?
> 
> Maybe you could put Stephen's BCMring patch on top when sending
> it in (also Acked-by) so we can avoid having that dangling.

s/bcmring/bcm2835/ :-)
