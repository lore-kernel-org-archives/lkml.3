Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753887Ab3IWNud (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 09:50:33 -0400
Received: from gloria.sntech.de ([95.129.55.99]:59968 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753418Ab3IWNub (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 09:50:31 -0400
From: Heiko =?utf-8?q?St=C3=BCbner?= <heiko@sntech.de>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [PATCH v2] Input: add driver for Neonode zForce based touchscreens
Date: Mon, 23 Sep 2013 15:50:26 +0200
User-Agent: KMail/1.13.7 (Linux/3.2.0-3-686-pae; KDE/4.8.4; i686; ; )
Cc: Henrik Rydberg <rydberg@euromail.se>, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org
References: <201309070133.11671.heiko@sntech.de>
In-Reply-To: <201309070133.11671.heiko@sntech.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <201309231550.27313.heiko@sntech.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Samstag, 7. September 2013, 01:33:11 schrieb Heiko Stübner:
> This adds a driver for touchscreens using the zforce infrared
> technology from Neonode connected via i2c to the host system.
> 
> It supports multitouch with up to two fingers and tracking of the
> contacts in hardware.
> 
> Signed-off-by: Heiko Stuebner <heiko@sntech.de>
> ---
> changes since v1:
> - address comments from Dmitry Torokhov
>   but I kept the access_mutex due to the possible race I described in the
> mail:
>   - touch -> interrupt
>   - isr reads first packet
>   - user closes device -> stop command sent
>   - isr reads payload
> - address comments from Henrik Rydberg, letting the input system collect
>   singletouch from the multitouch data using the appropriate functions

ping?


Thanks
Heiko
