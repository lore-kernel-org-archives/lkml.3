Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757480Ab3HMLrc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 07:47:32 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:51152 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756974Ab3HMLrb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 07:47:31 -0400
Message-ID: <520A1CCF.8000501@baylibre.com>
Date: Tue, 13 Aug 2013 13:47:27 +0200
From: Benoit Cousson <bcousson@baylibre.com>
Organization: BayLibre
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
CC: Benoit Cousson <benoit.cousson@linaro.org>,
        Tony Lindgren <tony@atomide.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-omap@vger.kernel.org
Subject: Re: [PATCH] ARM: DTS: AM33XX: Add PMU support
References: <1375552854-8468-1-git-send-email-alexandre.belloni@free-electrons.com>
In-Reply-To: <1375552854-8468-1-git-send-email-alexandre.belloni@free-electrons.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Salut Alexandre,

On 03/08/2013 20:00, Alexandre Belloni wrote:
> ARM Performance Monitor Units are available on the am33xx, add the support in
> the dtsi.
>
> Tested with perf and oprofile on a regular beaglebone.
>
> Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>

Thanks, applied for 3.12.

Regards,
Benoit

