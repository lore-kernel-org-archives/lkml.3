Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754637AbaIHRan (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 13:30:43 -0400
Received: from mail-la0-f47.google.com ([209.85.215.47]:54295 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754443AbaIHRak (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 13:30:40 -0400
X-Google-Original-Sender: <johan@hovold.com>
Date: Mon, 8 Sep 2014 19:28:39 +0200
From: Johan Hovold <johan@kernel.org>
To: Octavian Purdila <octavian.purdila@intel.com>
Cc: Johan Hovold <johan@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>, wsa@the-dreams.de,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Daniel Baluta <daniel.baluta@intel.com>,
        Laurentiu Palcu <laurentiu.palcu@intel.com>, linux-usb@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>, linux-gpio@vger.kernel.org,
        linux-i2c@vger.kernel.org
Subject: Re: [PATCH v3 2/3] i2c: add support for Diolan DLN-2 USB-I2C adapter
Message-ID: <20140908172839.GA21369@localhost>
References: <1409930279-1382-1-git-send-email-octavian.purdila@intel.com>
 <1409930279-1382-3-git-send-email-octavian.purdila@intel.com>
 <20140908144447.GD9560@localhost>
 <CAE1zot+R25OAu9d9WB2tOFqO9J9m-Vwo25msn6TD2HxseBTUzQ@mail.gmail.com>
 <20140908163058.GF9560@localhost>
 <CAE1zotJomxwAJA3aXm9MHnHd5Pg9V=K7XaptOPWkArV0jio4DQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAE1zotJomxwAJA3aXm9MHnHd5Pg9V=K7XaptOPWkArV0jio4DQ@mail.gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 08, 2014 at 08:15:07PM +0300, Octavian Purdila wrote:

> Just one more question on this subject: is the following allowed:
> 
> int ret, len;
> 
> or should it be:
> 
> int ret;
> int len;

I try to avoid it, at least unless obviously related such as min/max or
x/y.

Johan
