Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932215AbaJGR6W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 13:58:22 -0400
Received: from mail-la0-f50.google.com ([209.85.215.50]:58749 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753176AbaJGR6U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 13:58:20 -0400
X-Google-Original-Sender: <johan@hovold.com>
Date: Tue, 7 Oct 2014 19:55:28 +0200
From: Johan Hovold <johan@kernel.org>
To: Octavian Purdila <octavian.purdila@intel.com>
Cc: Johan Hovold <johan@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>, Wolfram Sang <wsa@the-dreams.de>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Daniel Baluta <daniel.baluta@intel.com>,
        Laurentiu Palcu <laurentiu.palcu@intel.com>, linux-usb@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        linux-i2c@vger.kernel.org
Subject: Re: [PATCH v6 2/4] i2c: add support for Diolan DLN-2 USB-I2C adapter
Message-ID: <20141007175528.GJ5362@localhost>
References: <1411661254-5204-1-git-send-email-octavian.purdila@intel.com>
 <1411661254-5204-3-git-send-email-octavian.purdila@intel.com>
 <20141007164636.GG5362@localhost>
 <CAE1zotKiYGXDbE0yVOz1ROuTxMf_Sfpn-0ghOM1dLEu1oEGZuw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAE1zotKiYGXDbE0yVOz1ROuTxMf_Sfpn-0ghOM1dLEu1oEGZuw@mail.gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 07, 2014 at 08:52:35PM +0300, Octavian Purdila wrote:
> On Tue, Oct 7, 2014 at 7:46 PM, Johan Hovold <johan@kernel.org> wrote:
> > On Thu, Sep 25, 2014 at 07:07:32PM +0300, Octavian Purdila wrote:

> >> +static DEVICE_ATTR_RW(dln2_i2c_freq);
> >
> > You forgot to add the required documentation of the attribute to
> > Documentation/ABI as requested.
> >
> 
> Hmm, I did add a new entry in Documentation/ABI/ at
> testing/sysfs-bus-i2c-busses-dln2. It should be right at the beginning
> at the patch.

Ah, sorry, I missed that. I'll look at it tomorrow.

Johan
