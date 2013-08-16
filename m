Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754246Ab3HPPme (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 11:42:34 -0400
Received: from mail-ob0-f181.google.com ([209.85.214.181]:64199 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753239Ab3HPPm0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 11:42:26 -0400
MIME-Version: 1.0
In-Reply-To: <82440653.410050.1376665340121.JavaMail.root@mail>
References: <CACRpkdZdeVNtJSmc6Lr6j=oO9FLsAvjyrwhYS0j4OoAEhxCN9g@mail.gmail.com>
	<82440653.410050.1376665340121.JavaMail.root@mail>
Date: Fri, 16 Aug 2013 17:42:25 +0200
Message-ID: <CACRpkdYX_u3yn0AhyMpCSYoQQJdaWJeK_GztxNM_LUL15WpAhA@mail.gmail.com>
Subject: Re: [PATCH] gpio: (gpio-pca953x) move header to linux/platform_data/
From: Linus Walleij <linus.walleij@linaro.org>
To: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
Cc: "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        kernel@savoirfairelinux.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 16, 2013 at 5:02 PM, Vivien Didelot
<vivien.didelot@savoirfairelinux.com> wrote:

>> Why does the GPIO driver need platform data from the
>> I2C driver???
>>
>> Can't this just be made to go away?
>
> I didn't dig that much in the driver, but I cannot imagine
> another way to pass, for instance, the setup callback.

Hm so this is some combined platform data for I2C *and* GPIO?

Hmm ugly, but OK then.
Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
