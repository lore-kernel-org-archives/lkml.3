Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751861AbaL3GRt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2014 01:17:49 -0500
Received: from senator.holtmann.net ([87.106.208.187]:50912 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751570AbaL3GRs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2014 01:17:48 -0500
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 8.1 \(1993\))
Subject: Re: [PATCH 3/3] net: ieee802154: don't use devm_pinctrl_get_select_default() in probe
From: Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <1419286616-9893-3-git-send-email-wsa@the-dreams.de>
Date: Mon, 29 Dec 2014 22:17:43 -0800
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-gpio@vger.kernel.org, Varka Bhadram <varkabhadram@gmail.com>,
        Alexander Aring <alex.aring@gmail.com>, linux-wpan@vger.kernel.org,
        netdev@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <6FEBBFCF-765F-4324-A9B1-92E47826F24A@holtmann.org>
References: <1419286616-9893-1-git-send-email-wsa@the-dreams.de> <1419286616-9893-3-git-send-email-wsa@the-dreams.de>
To: Wolfram Sang <wsa@the-dreams.de>
X-Mailer: Apple Mail (2.1993)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wolfram,

> Since commit ab78029ecc34 (drivers/pinctrl: grab default handles from device
> core), we can rely on device core for setting the default pins.
> 
> Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
> ---
> drivers/net/ieee802154/cc2520.c | 7 -------
> 1 file changed, 7 deletions(-)

patch has been applied to bluetooth-next tree.

Regards

Marcel

