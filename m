Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750984AbaKYPNV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 10:13:21 -0500
Received: from bhuna.collabora.co.uk ([93.93.135.160]:39827 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750780AbaKYPNT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 10:13:19 -0500
Message-ID: <54749C80.3050702@collabora.co.uk>
Date: Tue, 25 Nov 2014 16:13:04 +0100
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.0
MIME-Version: 1.0
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
CC: Mike Turquette <mturquette@linaro.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>, Kukjin Kim <kgene@kernel.org>,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Vivek Gautam <gautam.vivek@samsung.com>,
        Kevin Hilman <khilman@kernel.org>
Subject: Re: [RFC 0/2] Fix Arndale Octa/Peach Pi boot on Audio subsystem clocks
References: <1416842312-4405-1-git-send-email-k.kozlowski@samsung.com> <54736AD0.4070909@collabora.co.uk> <1416907375.5023.54.camel@AMDC1943> <547485F5.50600@collabora.co.uk> <1416925325.26128.6.camel@AMDC1943> <547497B2.3010907@collabora.co.uk> <1416927292.26128.8.camel@AMDC1943>
In-Reply-To: <1416927292.26128.8.camel@AMDC1943>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Krzysztof,

On 11/25/2014 03:54 PM, Krzysztof Kozlowski wrote:
> 
> My patch only fixed the gate clocks but it didn't touched div and mux.
> I'll prepare a v2 of it (I got some feedback) which I hope will fix both
> cases: i2s and disabling unused clocks.
>

Perfect, I will gladly test on Peach boards once you post it.

Thanks a lot for your help.

Best regards,
Javier
