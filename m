Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752501AbaEWNJw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 09:09:52 -0400
Received: from yotta.elopez.com.ar ([31.220.24.173]:33405 "EHLO
	yotta.elopez.com.ar" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750981AbaEWNJu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 09:09:50 -0400
Message-ID: <537F486D.9060900@elopez.com.ar>
Date: Fri, 23 May 2014 10:09:01 -0300
From: =?ISO-8859-1?Q?Emilio_L=F3pez?= <emilio@elopez.com.ar>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Chen-Yu Tsai <wens@csie.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mike Turquette <mturquette@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>, linux-serial@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Luc Verhaegen <libv@skynet.be>
Subject: Re: [PATCH 07/22] clk: sunxi: Fix PLL6 calculation on sun6i
References: <1400831485-28576-1-git-send-email-wens@csie.org> <1400831485-28576-8-git-send-email-wens@csie.org>
In-Reply-To: <1400831485-28576-8-git-send-email-wens@csie.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

El 23/05/14 04:51, Chen-Yu Tsai escribió:
> The N factor for PLL6 counts from 1 to 32, as specified in the A23
> manual, and shown in Allwinner's original code.

Are you sure about this? The A23 manual I'm looking at has a 5-bit field 
(so 0-31) on 12:8, and the examples count from 0 (eg Factor=0 N=1 ... 
Factor=31 N=32).

Cheers,

Emilio
