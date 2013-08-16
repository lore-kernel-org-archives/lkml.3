Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755295Ab3HPJqB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 05:46:01 -0400
Received: from mail-oa0-f49.google.com ([209.85.219.49]:35734 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754904Ab3HPJp5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 05:45:57 -0400
MIME-Version: 1.0
In-Reply-To: <1376643218.59144.YahooMailNeo@web160103.mail.bf1.yahoo.com>
References: <1376643218.59144.YahooMailNeo@web160103.mail.bf1.yahoo.com>
Date: Fri, 16 Aug 2013 18:45:56 +0900
Message-ID: <CADoNuNfiX7bNKB8eRjeiA+9vBnExgDsCjzUJv4ji7xUw1g35dw@mail.gmail.com>
Subject: Re: usb: misc: usb3503: connect and intn mismatch in OF vs variable assignments
From: Dongjin Kim <tobetter@gmail.com>
To: Alban Browaeys <prahal@yahoo.com>
Cc: Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The patch is submitted by Mark Brown a week ago, and might be queued already.

[1] http://www.spinics.net/lists/linux-usb/msg91410.html

Thanks,
Dongjin.

On Fri, Aug 16, 2013 at 5:53 PM, Alban Browaeys <prahal@yahoo.com> wrote:
> hub->gpio_intn  = of_get_named_gpio(np, "connect-gpios", 0);
> and
> hub->gpio_connect = of_get_named_gpio(np, "intn-gpios", 0);
>
> I guess they should be switched , that is connect-gpios bound to hub->gpio_connect
> and intn-gpios to hub->gpio_int.
>
> Sorry not to provides a patch. I thought that this issue might ends up with dts relying
> on this broken behaviour if not pointed early ...
> Either way if not fixed soon , I will have completed my branch cleanup (I also have other patches
> to this file ie drivers/usb/misc/usb3503.c).
>
> Best regards
> Alban
>
