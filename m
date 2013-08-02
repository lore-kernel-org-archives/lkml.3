Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753782Ab3HBOZY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 10:25:24 -0400
Received: from zetta.elopez.com.ar ([199.30.59.35]:57272 "EHLO
	zetta.elopez.com.ar" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753647Ab3HBOZW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 10:25:22 -0400
Message-ID: <51FBC13E.9060805@elopez.com.ar>
Date: Fri, 02 Aug 2013 11:25:02 -0300
From: =?ISO-8859-1?Q?Emilio_L=F3pez?= <emilio@elopez.com.ar>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Maxime Ripard <maxime.ripard@free-electrons.com>
CC: Mike Turquette <mturquette@linaro.org>, kevin.z.m.zh@gmail.com,
        sunny@allwinnertech.com, shuge@allwinnertech.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] clk: sunxi: Add A10s gates
References: <1374618504-19391-1-git-send-email-maxime.ripard@free-electrons.com> <1374618504-19391-2-git-send-email-maxime.ripard@free-electrons.com>
In-Reply-To: <1374618504-19391-2-git-send-email-maxime.ripard@free-electrons.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Maxime,

El 23/07/13 19:28, Maxime Ripard escribió:
> The Allwinner A10s has a slightly different gates set than the A10 and
> A13, so add these gates to the clk driver.
> 
> Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>

Looks good to me, and my A10S board still boots, so

Tested-by: Emilio López <emilio@elopez.com.ar>
Reviewed-by: Emilio López <emilio@elopez.com.ar>

Thanks!

Emilio
