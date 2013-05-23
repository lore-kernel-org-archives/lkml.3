Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751641Ab3EWG2w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 02:28:52 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:49366 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751320Ab3EWG2u convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 02:28:50 -0400
From: "Philip, Avinash" <avinashphilip@ti.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: "Nori, Sekhar" <nsekhar@ti.com>,
        "khilman@deeprootsystems.com" <khilman@deeprootsystems.com>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 02/11] gpio: davinci: coding style correction
Thread-Topic: [PATCH 02/11] gpio: davinci: coding style correction
Thread-Index: AQHOVrtT3nJPdPxYF0+o1KIziSzAUZkQwRgAgAGN5SA=
Date: Thu, 23 May 2013 06:27:09 +0000
Deferred-Delivery: Thu, 23 May 2013 06:27:00 +0000
Message-ID: <518397C60809E147AF5323E0420B992E3EAC7AE8@DBDE04.ent.ti.com>
References: <1369206634-6778-1-git-send-email-avinashphilip@ti.com>
 <1369206634-6778-3-git-send-email-avinashphilip@ti.com>
 <20130522144042.GG18614@n2100.arm.linux.org.uk>
In-Reply-To: <20130522144042.GG18614@n2100.arm.linux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.170.142]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 22, 2013 at 20:10:42, Russell King - ARM Linux wrote:
> On Wed, May 22, 2013 at 12:40:25PM +0530, Philip Avinash wrote:
> >  /*
> >   * Assuming the pin is muxed as a gpio output, set its output value.
> >   */
> > -static void
> > -davinci_gpio_set(struct gpio_chip *chip, unsigned offset, int value)
> > +static void davinci_gpio_set(struct gpio_chip *chip, unsigned offset,
> > +		int value)
> 
> This kind of stuff is just churn.  If you read Documentation/CodingStyle:
> 
> Statements longer than 80 columns will be broken into sensible chunks, unless
> exceeding 80 columns significantly increases readability and does not hide
> information. Descendants are always substantially shorter than the parent and
> are placed substantially to the right. The same applies to function headers
> with a long argument list. However, never break user-visible strings such as
> printk messages, because that breaks the ability to grep for them.
> 
> "broken into sensible chunks".  Here's the question: is the former a
> sensible format?  Arguably it is because it results in all the arguments
> fitting on one line at the expense of missing the return value.
> 
> The latter is also a sensible format - but breaks the arguments instead
> of the return value.
> 
> Both formats can be found in their entirety by grep by function name alone:
> 
> 	grep -1 davinci_gpio_set
> 
> or if you prefer to type some more then you end up with more specific
> 
> 	grep -A1 davinci_gpio_set
> or
> 	grep -B1 davinci_gpio_set
> 
> depending on the version.
> 
> Where there's no clear advantage one way or the other, let the authors
> preference stand.

Ok I understood and I will remove these changes in next version.

Thanks
Avinash

> 

