Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932550Ab3DCUXs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 16:23:48 -0400
Received: from mail-ie0-f177.google.com ([209.85.223.177]:39711 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932459Ab3DCUXr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 16:23:47 -0400
MIME-Version: 1.0
In-Reply-To: <515C701E.1000402@prisktech.co.nz>
References: <1364970291-17721-1-git-send-email-linux@prisktech.co.nz>
	<CACRpkdZAtgpfA5rZ_C=eKDDOE9aDm=3k1QDava=EGL2BaoV+0g@mail.gmail.com>
	<515C701E.1000402@prisktech.co.nz>
Date: Wed, 3 Apr 2013 22:23:46 +0200
Message-ID: <CACRpkdapvxK6ad4PGasb0XKjPYJabpvwZhx+o72iwbCZFkkZFg@mail.gmail.com>
Subject: Re: [PATCHv5 0/7] arm: vt8500: Add support for pinctrl/gpio module
From: Linus Walleij <linus.walleij@linaro.org>
To: Tony Prisk <linux@prisktech.co.nz>
Cc: Rob Herring <robherring2@gmail.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "vt8500-wm8505-linux-kernel@googlegroups.com" 
	<vt8500-wm8505-linux-kernel@googlegroups.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 3, 2013 at 8:08 PM, Tony Prisk <linux@prisktech.co.nz> wrote:
> On 04/04/13 02:40, Linus Walleij wrote:

>> This v5 series:
>> Acked-by: Linus Walleij <linus.walleij@linaro.org>
>>
>> I guess it will go in through the VT8500 tree eventually?
>>
>> Maybe you could put Stephen's BCMring patch on top when sending
>> it in (also Acked-by) so we can avoid having that dangling.
>>
>> Yours,
>> Linus Walleij
>
> We don't have a VT8500 tree. Originally I planned for it to go through you,
> but it could go through arm-soc if they want to take it.

You should definately be sending VT8500 series like this through
ARM SoC. Prepare a pull request or patch series and
send to arm@kernel.org.

Thanks,
Linus Walleij
