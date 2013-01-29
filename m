Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751919Ab3A2WyU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 17:54:20 -0500
Received: from mail.free-electrons.com ([94.23.35.102]:37440 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751067Ab3A2WyS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 17:54:18 -0500
Message-ID: <51085315.2000302@free-electrons.com>
Date: Tue, 29 Jan 2013 23:54:13 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: linux-arm-kernel@lists.infradead.org, Emilio Lopez <emilio@elopez.com.ar>,
        Alejandro Mery <amery@geeks.cl>, Stefan Roese <sr@denx.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] pinctrl: sunxi: Add of_xlate function
References: <1359313332-12305-1-git-send-email-maxime.ripard@free-electrons.com> <1359313332-12305-2-git-send-email-maxime.ripard@free-electrons.com> <CACRpkdZi0zCNf6LDd9UAcd57kFqqWyteVqxL8WfDrFfrt9_5sQ@mail.gmail.com>
In-Reply-To: <CACRpkdZi0zCNf6LDd9UAcd57kFqqWyteVqxL8WfDrFfrt9_5sQ@mail.gmail.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 29/01/2013 23:41, Linus Walleij a écrit :
> On Sun, Jan 27, 2013 at 8:02 PM, Maxime Ripard
> <maxime.ripard@free-electrons.com> wrote:
> 
>> Since the pin controller of sunxi chips is represented as a single bank
>> in the driver.
>> Since this is neither convenient nor represented that way in the
>> datasheets, define a custom of_xlate function with the layout <bank pin
>> flag>
>>
>> Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
> 
> This does not apply and I only have 1/3 it seems?
> 
> Sorry, help me understand which order these patches go in...

My bad, I forgot to mention the order of the patchsets, and to cc you
for the all series... Sorry about that.

This patch should come after the patch series that adds the support for
the A10 SoCs in the pinctrl driver.

Do you want me to resend this serie and cc you?

Maxime

-- 
Maxime Ripard, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
