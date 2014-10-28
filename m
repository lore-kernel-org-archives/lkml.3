Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755740AbaJ1Iuj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 04:50:39 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:58518 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751066AbaJ1Iug (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 04:50:36 -0400
Message-ID: <544F58D6.8010802@collabora.co.uk>
Date: Tue, 28 Oct 2014 09:50:30 +0100
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.0
MIME-Version: 1.0
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
CC: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        linux-kernel@vger.kernel.org, Ben Dooks <ben-linux@fluff.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, devicetree@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: Re: [PATCH 1/8] regulator: max77802: Remove support for board files
References: <1414422226-10948-1-git-send-email-k.kozlowski@samsung.com> <1414422226-10948-2-git-send-email-k.kozlowski@samsung.com> <544E9EB2.2010408@collabora.co.uk> <1414485916.24949.15.camel@AMDC1943>
In-Reply-To: <1414485916.24949.15.camel@AMDC1943>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Krzysztof,

On 10/28/2014 09:45 AM, Krzysztof Kozlowski wrote:
> 
> Thanks! However Mark had some comments which will reorganize the patch
> completely. I'll be sending next version and probably I would need your
> ack and testing again.
> 

Sure, I can test your patches if you don't have access to a machine with
the max77802 PMIC.

Best regards,
Javier
