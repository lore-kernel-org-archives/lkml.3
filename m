Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756763AbaIROXz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 10:23:55 -0400
Received: from mail-lb0-f179.google.com ([209.85.217.179]:35558 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756696AbaIROXx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 10:23:53 -0400
X-Google-Original-Sender: <johan@hovold.com>
Date: Thu, 18 Sep 2014 16:21:29 +0200
From: Johan Hovold <johan@kernel.org>
To: Octavian Purdila <octavian.purdila@intel.com>
Cc: gregkh@linuxfoundation.org, linus.walleij@linaro.org, gnurou@gmail.com,
        wsa@the-dreams.de, sameo@linux.intel.com, lee.jones@linaro.org,
        arnd@arndb.de, johan@kernel.org, daniel.baluta@intel.com,
        laurentiu.palcu@intel.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-gpio@vger.kernel.org,
        linux-i2c@vger.kernel.org
Subject: Re: [PATCH v4 1/3] mfd: add support for Diolan DLN-2 devices
Message-ID: <20140918142129.GC26817@localhost>
References: <1410290686-6680-1-git-send-email-octavian.purdila@intel.com>
 <1410290686-6680-2-git-send-email-octavian.purdila@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410290686-6680-2-git-send-email-octavian.purdila@intel.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 09, 2014 at 10:24:44PM +0300, Octavian Purdila wrote:

> +MODULE_AUTHOR("Octavian Purdila <octavian.purdila@intel.com>");
> +MODULE_DESCRIPTION(DRIVER_NAME " driver");
> +MODULE_LICENSE("GPL");

Just noticed both the i2c and gpio driver is lacking a MODULE_ALIAS to
enable module auto-loading.

Johan
