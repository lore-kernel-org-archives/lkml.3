Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935519Ab3DISvS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 14:51:18 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:63717 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761645Ab3DISvR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 14:51:17 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH 8/8] ARM: ux500: Amalgamate DMA source and destination channel numbers
Date: Tue, 9 Apr 2013 20:51:12 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-16-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@stericsson.com
References: <1365532783-27425-1-git-send-email-lee.jones@linaro.org> <1365532783-27425-8-git-send-email-lee.jones@linaro.org>
In-Reply-To: <1365532783-27425-8-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201304092051.13138.arnd@arndb.de>
X-Provags-ID: V02:K0:0ew4WNnegBjYpndpFJWxcxy+HA2rrsRwKiUPS7goimi
 JSCiO3k7F6DsLd7LG2lpnnpyhyvcgbZPEW8vjDnSS0udc33QEI
 AMD0AbKWWQiULcvFCrOiAoGazJwgKEe3e3ZT8K37PQyjIMyT95
 SA+8LdasnI8BjpxRuU11EclhsJX/S3JE+aFunjVKIyPuH1acy/
 cQbVhoKX1aCF1xF6oAvavBZKMlytyXrv7irEpGK0gvKmM35E93
 QrnZgx4DOhCaxFr52M3CZYwLI68SMtVPXBVAsyMse9l+1Y8Dru
 bE3Fi7VFSh/lGdfIcQf7FUQSy+XbKK7OHCcf9d5mMGrv2mBDm4
 33mbHV2X6XtHLAdY6FUU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 09 April 2013, Lee Jones wrote:
> Devices which utilise DMA tend to use the same channel numbers for
> transmitting and receiving. For this reason and the fact that it'll
> decrease the burden of platform data passed to each device, we're
> amalgamating source and destination device types.
> 
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Very nice cleanup!

Acked-by: Arnd Bergmann <arnd@arndb.de>
