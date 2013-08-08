Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934018Ab3HHIML (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 04:12:11 -0400
Received: from sauhun.de ([89.238.76.85]:35762 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933922Ab3HHIMI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 04:12:08 -0400
Date: Thu, 8 Aug 2013 10:12:00 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Nguyen Viet Dung <nv-dung@jinso.co.jp>
Cc: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        kuninori.morimoto.gx@renesas.com
Subject: Re: [PATCH v2 1/1 resend] i2c: rcar: modify I2C driver
Message-ID: <20130808080819.GA6070@the-dreams.de>
References: <1375687174-577-1-git-send-email-nv-dung@jinso.co.jp>
 <1375687174-577-2-git-send-email-nv-dung@jinso.co.jp>
 <20130807151234.GH2978@katana>
 <5202F0AC.4070609@jinso.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5202F0AC.4070609@jinso.co.jp>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 08, 2013 at 10:13:16AM +0900, Nguyen Viet Dung wrote:

> Difference between H2 and H1 in hardware is only CDF bit of ICCCR register.

No IP version register? Sigh...

> If this method is not a common method, please tell me about common method.

Use a new platform_device_id and populate the driver_data with the info
needed to distinguish between the revisions. Check i2c-imx.c for an
example.

