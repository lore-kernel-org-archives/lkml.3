Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753581AbaFBUda (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 16:33:30 -0400
Received: from mout.perfora.net ([74.208.4.194]:49365 "EHLO mout.perfora.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751955AbaFBUd1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 16:33:27 -0400
Message-ID: <538CDF7E.6080602@ziswiler.com>
Date: Mon, 02 Jun 2014 22:33:02 +0200
From: Marcel Ziswiler <marcel@ziswiler.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>, Olof Johansson <olof@lixom.net>
CC: Thierry Reding <thierry.reding@gmail.com>,
        "arm@kernel.org" <arm@kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        stefan@agner.ch
Subject: Re: [PATCH 1/3] arm: multi_v7: enable igb, stmpe, spidev, lm95245,
 pwm leds
References: <cc612cd3f24f01cfc8fd3e81b1027ff94862e8b4.1401700579.git.marcel@ziswiler.com> <CAOesGMg6aBpH18VO6XF1HxbXsJy92QadT3MVT2vOY41s=oCRrw@mail.gmail.com> <538CB143.5020504@wwwdotorg.org>
In-Reply-To: <538CB143.5020504@wwwdotorg.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V02:K0:sfZ7IhVJLMKrpCt99T60/DtoAhbsbnmbza4njS7UpUW
 h6e3N9CIDjopEv2fSU9+TwOVVfGNQxJseXZWAkbhjkk+BAxe9+
 rVj255KsLwhPS1Wnja5K7Oc4vbhBLjJ/oLiM5HIVuZxrnUhw6j
 HIt/6fBnOl+wDjVHHqk9tBb2v93R07g7yZAg7Oly4+cfjN+TIK
 66xN5eRyhvG/3Ytc82uCmlUyJ6K+HVHbSjxxX5ECRdz0T32m5M
 CGCiKKf8zyE2CWpMEUI2QvjmWxDta6/BrMbv6gzwvLUIdnB++a
 +oM6Ks7tuhCRXz96XRh1HM+hYz6y1SKBnL9T4ybf04eR3L7gFw
 +QOEshZ/eEdnQP1fsgmk=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/02/2014 07:15 PM, Stephen Warren wrote:
> I think the content in this patch is for 3.17. The issues mentioned
> below --- would be worth fixing for 3.16.

It sure is your call. I feared it being too late for 3.16 now with Linus 
having opened the merge window presumably one week early.
