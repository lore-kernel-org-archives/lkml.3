Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753628AbaHMQ6x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 12:58:53 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:39002 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753165AbaHMQ6v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 12:58:51 -0400
Message-ID: <53EB9945.1020704@collabora.co.uk>
Date: Wed, 13 Aug 2014 18:58:45 +0200
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: Kukjin Kim <kgene.kim@samsung.com>, Doug Anderson <dianders@chromium.org>,
        Olof Johansson <olof@lixom.net>,
        Yuvaraj Kumar C D <yuvaraj.cd@gmail.com>,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/6] ARM: dts: Add tps65090 FETs constraints
References: <1407861868-20097-1-git-send-email-javier.martinez@collabora.co.uk> <1407861868-20097-7-git-send-email-javier.martinez@collabora.co.uk> <20140812172552.GU17528@sirena.org.uk> <53EA61B9.2070805@collabora.co.uk> <20140812212757.GY17528@sirena.org.uk> <53EB4CA0.3010006@collabora.co.uk> <20140813122910.GQ17528@sirena.org.uk> <53EB6954.3040207@collabora.co.uk> <20140813155122.GX17528@sirena.org.uk>
In-Reply-To: <20140813155122.GX17528@sirena.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Mark,

On 08/13/2014 05:51 PM, Mark Brown wrote:
> On Wed, Aug 13, 2014 at 03:34:12PM +0200, Javier Martinez Canillas wrote:
> 
>> Indeed. I'll change mmc_regulator_get_ocrmask() in MMC core then to use
>> regulator_can_change_voltage() to detect if the regulator is a fixed one
>> and call regulator_get_voltage() instead of list_voltage() in that case.
> 
>> Do you agree that this is the correct solution?
> 
> I would just fall back to get_voltage() if there are no voltages listed,
> that seems more robust.
> 

Great, thanks a lot for your suggestion and all the help.

Best regards,
Javier
