Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752336AbaKGQTs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 11:19:48 -0500
Received: from bhuna.collabora.co.uk ([93.93.135.160]:44492 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751437AbaKGQTq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 11:19:46 -0500
Message-ID: <545CF11C.3000706@collabora.co.uk>
Date: Fri, 07 Nov 2014 17:19:40 +0100
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
Subject: Re: [PATCH v5 1/5] regulator: Document binding for initial and suspend
 modes
References: <1415365205-27630-1-git-send-email-javier.martinez@collabora.co.uk> <1415365205-27630-2-git-send-email-javier.martinez@collabora.co.uk> <20141107145806.GQ8509@sirena.org.uk> <545CE75C.8000408@collabora.co.uk> <20141107161029.GV8509@sirena.org.uk>
In-Reply-To: <20141107161029.GV8509@sirena.org.uk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Mark,

On 11/07/2014 05:10 PM, Mark Brown wrote:
> 
> You're also saying that the OS won't manage the mode here, that's a step
> further.
>

I see
 
>> So should I just explain what each property is about without trying to make
>> assumptions about the limitations that different devices could have and let
>> each device DT binding to specify those?
> 
> More towards that direction, yes.  Don't overspecify.
> 

Got it, thanks a lot for your valuable feedback.

Best regards,
Javier
