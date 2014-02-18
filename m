Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755775AbaBROr0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 09:47:26 -0500
Received: from yotta.elopez.com.ar ([31.220.24.173]:43069 "EHLO
	yotta.elopez.com.ar" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755536AbaBROrZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 09:47:25 -0500
Message-ID: <53037267.1000909@elopez.com.ar>
Date: Tue, 18 Feb 2014 11:47:03 -0300
From: =?ISO-8859-1?Q?Emilio_L=F3pez?= <emilio@elopez.com.ar>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Maxime Ripard <maxime.ripard@free-electrons.com>,
        Mark Brown <broonie@kernel.org>,
        Mike Turquette <mturquette@linaro.org>
CC: linux-sunxi@googlegroups.com, linux-spi@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, kevin.z.m.zh@gmail.com,
        sunny@allwinnertech.com, shuge@allwinnertech.com,
        zhuzhenhua@allwinnertech.com
Subject: Re: [PATCH v4 1/5] clk: sunxi: Add support for PLL6 on the A31
References: <1391605507-30981-1-git-send-email-maxime.ripard@free-electrons.com> <1391605507-30981-2-git-send-email-maxime.ripard@free-electrons.com>
In-Reply-To: <1391605507-30981-2-git-send-email-maxime.ripard@free-electrons.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

El 05/02/14 10:05, Maxime Ripard escribió:
> The A31 has a slightly different PLL6 clock. Add support for this new clock in
> our driver.
>
> Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>

Taken via sunxi-clk-for-mike.

Thanks!

Emilio
