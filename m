Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757185Ab3KYRKT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 12:10:19 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:40950 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754591Ab3KYRKQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 12:10:16 -0500
Message-ID: <529382E9.8030309@wwwdotorg.org>
Date: Mon, 25 Nov 2013 10:03:37 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Florian Meier <florian.meier@koalo.de>, Wolfram Sang <wsa@the-dreams.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-rpi-kernel <linux-rpi-kernel@lists.infradead.org>,
        linux-i2c@vger.kernel.org
Subject: Re: [PATCH] I2C: BCM2835: Linking platform nodes to adapter nodes
References: <529303EE.4080606@koalo.de>
In-Reply-To: <529303EE.4080606@koalo.de>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/25/2013 01:01 AM, Florian Meier wrote:
> In order to find I2C devices in the device tree, the platform nodes
> have to be known by the I2C core. This requires setting the
> dev.of_node parameter of the adapter.

Acked-by: Stephen Warren <swarren@wwwdotorg.org>
Tested-by: Stephen Warren <swarren@wwwdotorg.org>

(Interestingly, I just attached an I2C light sensor to my Pi a couple
days back, so ended up needing this commit, and the patches someone else
had very recently sent to add DT support to the sensor driver. My timing
was impeccable:-)
