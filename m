Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752191AbaLOKUe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 05:20:34 -0500
Received: from mout.kundenserver.de ([212.227.126.131]:54684 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750805AbaLOKU3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 05:20:29 -0500
Date: Mon, 15 Dec 2014 11:22:23 +0100
From: Nikolaus Schulz <nikolaus.schulz@avionic-design.de>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Jonathan Cameron <jic23@kernel.org>, Hartmut Knaack <knaack.h@gmx.de>,
        Peter Meerwald <pmeerw@pmeerw.net>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Michael Welling <mwelling@ieee.org>,
        Philippe Reynes <tremyfr@yahoo.fr>, linux-kernel@vger.kernel.org,
        linux-iio@vger.kernel.org, devicetree@vger.kernel.org,
        Alban Bedel <alban.bedel@avionic-design.de>
Subject: Re: [PATCH v2 2/2] iio: add driver for the TI DAC8554
Message-ID: <20141215102223.GB6159@avionic-0071.adnet.avionic-design.de>
References: <1416858614-32265-1-git-send-email-nikolaus.schulz@avionic-design.de>
 <1416858614-32265-2-git-send-email-nikolaus.schulz@avionic-design.de>
 <548C2335.7080301@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <548C2335.7080301@metafoo.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Content-Transfer-Encoding: 8BIT
X-Provags-ID: V03:K0:sA+FA2gAKmUu8CGwVeo5FU5CpgGIEQzXMqNucyKEyLbJxHlFG2e
 2+M5jDn1zLvy9bA2H2ykNN7FDCukwwybmUAenOcEiHb0ZhxbZnuyl0bto+zqsxNlAGikQLm
 xwDO7vzzS2KM5m9DtT49KoDMEMN4tnCzWelpoW5smjptRc5Fx9GMXwJrIF1kEfTqLI2gVTC
 AfDgRrPHN/kP9DYHHWOiw==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 13, 2014 at 12:29:57PM +0100, Lars-Peter Clausen wrote:
> On 11/24/2014 08:50 PM, Nikolaus Schulz wrote:
> [...]
> >+const struct iio_chan_spec dac8554_channels[] = {
> 
> static
> 
> [...]
> >+	ret = of_property_read_u32(spi->dev.of_node, "address", &addr);
> 
> This should probably have vendor prefix.

Both fixed in v3, thanks!

-- 
Avionic Design GmbH
Nikolaus Schulz
Wragekamp 10
D-22397 Hamburg
Germany

Tel.:  +49 40 88187-163
Fax:   +49 40 88187-150
Email: nikolaus.schulz@avionic-design.de

Avionic Design GmbH
Amtsgericht Hamburg HRB 82598
Geschäftsführung: Cornelis Broers
Ust.-Ident-Nr.: DE813378254
