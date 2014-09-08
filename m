Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754018AbaIHNYZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 09:24:25 -0400
Received: from mail-ig0-f169.google.com ([209.85.213.169]:65181 "EHLO
	mail-ig0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753988AbaIHNYW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 09:24:22 -0400
Date: Mon, 8 Sep 2014 14:24:15 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Octavian Purdila <octavian.purdila@intel.com>
Cc: Johan Hovold <johan@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>, wsa@the-dreams.de,
        Samuel Ortiz <sameo@linux.intel.com>, Arnd Bergmann <arnd@arndb.de>,
        Daniel Baluta <daniel.baluta@intel.com>,
        Laurentiu Palcu <laurentiu.palcu@intel.com>, linux-usb@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>, linux-gpio@vger.kernel.org,
        linux-i2c@vger.kernel.org
Subject: Re: [PATCH v3 1/3] mfd: add support for Diolan DLN-2 devices
Message-ID: <20140908132415.GB30307@lee--X1>
References: <1409930279-1382-1-git-send-email-octavian.purdila@intel.com>
 <1409930279-1382-2-git-send-email-octavian.purdila@intel.com>
 <20140908113233.GA9560@localhost>
 <CAE1zotL3rKb3ayjgp0DbTr-a9xAhEJk6ybdqGEzg3UtuBUKWMw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAE1zotL3rKb3ayjgp0DbTr-a9xAhEJk6ybdqGEzg3UtuBUKWMw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 08 Sep 2014, Octavian Purdila wrote:
> On Mon, Sep 8, 2014 at 2:32 PM, Johan Hovold <johan@kernel.org> wrote:
> >
> > On Fri, Sep 05, 2014 at 06:17:57PM +0300, Octavian Purdila wrote:
> > > This patch implements the USB part of the Diolan USB-I2C/SPI/GPIO
> > > Master Adapter DLN-2. Details about the device can be found here:
> > >
> <snip>
> >
> > First of all, this is much cleaner than the first non-MFD version. I'll
> > have a look at the subdrivers shortly as well.
> >
> 
> Hi Johan,
> 
> I have addressed all you comments except one, please see bellow. I
> will wait for the review on the subdrivers before submitting a new
> version of the patch set. Thanks for for review !

No, please don't.  Fix-up and resubmit.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
