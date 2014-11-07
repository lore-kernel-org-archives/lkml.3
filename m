Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752044AbaKGQSA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 11:18:00 -0500
Received: from bhuna.collabora.co.uk ([93.93.135.160]:44483 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751249AbaKGQR6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 11:17:58 -0500
Message-ID: <545CF0B0.3030009@collabora.co.uk>
Date: Fri, 07 Nov 2014 17:17:52 +0100
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.0
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: Kukjin Kim <kgene.kim@samsung.com>, Chanwoo Choi <cw00.choi@samsung.com>,
        Olof Johansson <olof@lixom.net>, Chris Zhong <zyw@rock-chips.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Abhilash Kesavan <kesavan.abhilash@gmail.com>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v5 2/5] regulator: Add function to map modes to struct
 regulator_desc
References: <1415365205-27630-1-git-send-email-javier.martinez@collabora.co.uk> <1415365205-27630-3-git-send-email-javier.martinez@collabora.co.uk> <20141107155400.GU8509@sirena.org.uk>
In-Reply-To: <20141107155400.GU8509@sirena.org.uk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/07/2014 04:54 PM, Mark Brown wrote:
> of_map_mode - it's only one mode and this is mapping to/from DT.
>

Ok
 
>> + *             If the callback is not defined, the "regulator-initial-mode"
>> + *             and suspend states "regulator-mode" properties won't be parsed.
> 
> Just remove this, it's pretty obvious at best and going to bit rot at
> worst.
> 

Ok, it was not in a previous version but I added because Krzysztof said
that it may be good to have it documented. I'll remove it.

Best regards,
Javier
