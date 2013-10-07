Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752960Ab3JGLRM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 07:17:12 -0400
Received: from gloria.sntech.de ([95.129.55.99]:41978 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751436Ab3JGLRI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 07:17:08 -0400
From: Heiko =?utf-8?q?St=C3=BCbner?= <heiko@sntech.de>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>
Subject: Re: [PATCH v2] Input: add driver for Neonode zForce based touchscreens
Date: Mon, 7 Oct 2013 13:17:14 +0200
User-Agent: KMail/1.13.7 (Linux/3.2.0-2-amd64; KDE/4.8.4; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
References: <201309070133.11671.heiko@sntech.de> <201309231550.27313.heiko@sntech.de>
In-Reply-To: <201309231550.27313.heiko@sntech.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201310071317.15544.heiko@sntech.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Am Montag, 23. September 2013, 15:50:26 schrieb Heiko Stübner:
> Am Samstag, 7. September 2013, 01:33:11 schrieb Heiko Stübner:
> > This adds a driver for touchscreens using the zforce infrared
> > technology from Neonode connected via i2c to the host system.
> > 
> > It supports multitouch with up to two fingers and tracking of the
> > contacts in hardware.
> > 
> > Signed-off-by: Heiko Stuebner <heiko@sntech.de>
> > ---
> > changes since v1:
> > - address comments from Dmitry Torokhov
> > 
> >   but I kept the access_mutex due to the possible race I described in the
> > 
> > mail:
> >   - touch -> interrupt
> >   - isr reads first packet
> >   - user closes device -> stop command sent
> >   - isr reads payload
> > 
> > - address comments from Henrik Rydberg, letting the input system collect
> > 
> >   singletouch from the multitouch data using the appropriate functions
> 
> ping?
> 

is the driver ok in this form or is more work needed?


Thanks
Heiko
