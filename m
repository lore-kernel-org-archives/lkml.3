Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751870AbaHTQKI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 12:10:08 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:43309 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751506AbaHTQKH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 12:10:07 -0400
Message-ID: <53F4C858.4040202@collabora.co.uk>
Date: Wed, 20 Aug 2014 18:10:00 +0200
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Axel Lin <axel.lin@ingics.com>, Mark Brown <broonie@kernel.org>
CC: Liam Girdwood <lgirdwood@gmail.com>,
        Naveen Krishna Chatradhi <ch.naveen@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] regulator: max77802: Remove unused fields from struct
 max77802_regulator_prv
References: <1408500257.5309.2.camel@phoenix>
In-Reply-To: <1408500257.5309.2.camel@phoenix>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Axel,

On 08/20/2014 04:04 AM, Axel Lin wrote:
> Both num_regulators and *rdev[MAX77802_REG_MAX] are not used, remove them.
> 
> Signed-off-by: Axel Lin <axel.lin@ingics.com>

Right, these are not used indeed since are left overs from the previous
attempt to have a single driver for both max77686 and max77802 PMICs.
Sorry about that and thanks a lot for the patch.

>  
>  struct max77802_regulator_prv {
> -	int num_regulators;
> -	struct regulator_dev *rdev[MAX77802_REG_MAX];
>  	unsigned int opmode[MAX77802_REG_MAX];
>  };
>  
> 

I see that Mark already applied this but fwiw:

Acked-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>

Best regards,
Javier
