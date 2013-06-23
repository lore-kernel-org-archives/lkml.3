Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752099Ab3FWXIt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jun 2013 19:08:49 -0400
Received: from mout.gmx.net ([212.227.17.22]:64100 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751803Ab3FWXIs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jun 2013 19:08:48 -0400
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX18WqlF2dS4WeuzRfNg2HpGqF2riuGhyXFtRjCRj6M
	N8O7bdAjYKFo4a
From: Peter =?iso-8859-1?q?H=FCwe?= <PeterHuewe@gmx.de>
To: tpmdd-devel@lists.sourceforge.net, Peter Huewe <peter.huewe@infineon.com>
Subject: Re: [tpmdd-devel] [PATCH] tpm: tpm_i2c_infinion: Don't modify i2c_client->driver
Date: Mon, 24 Jun 2013 01:16:01 +0200
User-Agent: KMail/1.13.7 (Linux/3.8.11; KDE/4.9.5; x86_64; ; )
Cc: "Lars-Peter Clausen" <lars@metafoo.de>, linux-kernel@vger.kernel.org,
        shpedoikal@gmail.com
References: <1371306204-7547-1-git-send-email-lars@metafoo.de>
In-Reply-To: <1371306204-7547-1-git-send-email-lars@metafoo.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201306240116.02144.PeterHuewe@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Samstag, 15. Juni 2013, 16:23:24 schrieb Lars-Peter Clausen:
> The I2C client driver is not supposed to modify the client's driver
> pointer, this is handled by the I2C core.
> 
> Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
> ---
Nice catch.

Staged here:

https://github.com/PeterHuewe/linux-tpmdd/commits/for-james


Thanks,
Peter
