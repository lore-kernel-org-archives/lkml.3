Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752032AbaHTK2C (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 06:28:02 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:42988 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751910AbaHTK17 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 06:27:59 -0400
Message-ID: <53F47829.5040708@collabora.co.uk>
Date: Wed, 20 Aug 2014 12:27:53 +0200
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: =?ISO-8859-15?Q?Andreas_F=E4rber?= <afaerber@suse.de>
CC: Kukjin Kim <kgene.kim@samsung.com>, Doug Anderson <dianders@chromium.org>,
        Olof Johansson <olof@lixom.net>, Mark Brown <broonie@kernel.org>,
        Naveen Krishna Chatradhi <ch.naveen@samsung.com>,
        Rahul Sharma <rahul.sharma@samsung.com>,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] ARM: dts: Add Peach Pit and Pi dts entry for max77802
 PMIC
References: <1408460913-13863-1-git-send-email-javier.martinez@collabora.co.uk> <1408460913-13863-2-git-send-email-javier.martinez@collabora.co.uk> <53F39CE3.8040303@suse.de>
In-Reply-To: <53F39CE3.8040303@suse.de>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Andreas,

On 08/19/2014 08:52 PM, Andreas Färber wrote:
>> +
>> +	max77802-pmic@9 {
>> +		compatible = "maxim,max77802";
>> +		interrupt-parent = <&gpx3>;
>> +		interrupts = <1 0>;
> 
> <1 IRQ_TYPE_NONE>?
> 

Indeed, I'll change both on v2. Thanks a lot.

> 
> Cheers,
> Andreas
> 

Best regards,
Javier

