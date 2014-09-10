Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752027AbaIJJCq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 05:02:46 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:35236 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751048AbaIJJCo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 05:02:44 -0400
Message-ID: <541013AE.6090805@collabora.co.uk>
Date: Wed, 10 Sep 2014 11:02:38 +0200
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Doug Anderson <dianders@chromium.org>
CC: Kukjin Kim <kgene.kim@samsung.com>, Olof Johansson <olof@lixom.net>,
        Mark Brown <broonie@kernel.org>,
        Naveen Krishna Chatradhi <ch.naveen@samsung.com>,
        Rahul Sharma <rahul.sharma@samsung.com>,
        =?UTF-8?B?QW5kcmVhcyBGw6RyYmVy?= <afaerber@suse.de>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 5/5] ARM: dts: Add Peach Pit and Pi dts entry for ISL29018
 sensor
References: <1408533593-32346-1-git-send-email-javier.martinez@collabora.co.uk>	<1408533593-32346-6-git-send-email-javier.martinez@collabora.co.uk> <CAD=FV=WdMx=7oLChYz-y2cY=MBpJmT7KXBq_hMV7FS16VT+85w@mail.gmail.com>
In-Reply-To: <CAD=FV=WdMx=7oLChYz-y2cY=MBpJmT7KXBq_hMV7FS16VT+85w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Doug,

On 09/10/2014 06:52 AM, Doug Anderson wrote:
> 
> I would note that the downstream dts file has this i2c bus at 400kHz.
> ...but that's not a problem with your patch.  Perhaps you could submit
> that as a separate patch?
>

Indeed, I've to re-spin anyways so I'll include that on the next version as a
separate patch.

> Reviewed-by: Doug Anderson <dianders@chromium.org>
> 

Best regards,
Javier
