Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752080AbaKGPt5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 10:49:57 -0500
Received: from bhuna.collabora.co.uk ([93.93.135.160]:44439 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751797AbaKGPt4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 10:49:56 -0500
Message-ID: <545CEA1D.2020109@collabora.co.uk>
Date: Fri, 07 Nov 2014 16:49:49 +0100
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
Subject: Re: [PATCH v5 3/5] regulator: of: Add regulator desc param to of_get_regulator_init_data()
References: <1415365205-27630-1-git-send-email-javier.martinez@collabora.co.uk> <1415365205-27630-4-git-send-email-javier.martinez@collabora.co.uk> <20141107150743.GR8509@sirena.org.uk>
In-Reply-To: <20141107150743.GR8509@sirena.org.uk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Mark,

On 11/07/2014 04:07 PM, Mark Brown wrote:
> 
> This is using the regulator descriptor before it is initialized which
> doesn't seem ideal...
>

You are right, even if most of them are not used currently, that may
change in the future so is safer to use it after all fields have been
initialized. I'll double check all drivers to be sure that's the case.

> 
> This is just adding the include to get the declaration of regulator_desc
> as far as I can see, add a forward declaration of it instead.
> 

Perfect, I didn't know what you would prefer. I'll change it in the
next version.

Best regards,
Javier
