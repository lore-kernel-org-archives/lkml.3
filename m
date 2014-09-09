Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756872AbaIINIm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 09:08:42 -0400
Received: from demumfd001.nsn-inter.net ([93.183.12.32]:52058 "EHLO
	demumfd001.nsn-inter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753619AbaIINIi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 09:08:38 -0400
Date: Tue, 9 Sep 2014 17:11:55 +0300
From: Matti Vaittinen <matti.vaittinen@nsn.com>
To: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        "jason@lakedaemon.net" <jason@lakedaemon.net>,
        "linux@roeck-us.net" <linux@roeck-us.net>
Cc: a.zummo@towertech.it, "jic23@kernel.org" <jic23@kernel.org>,
        "arno@natisbad.org" <arno@natisbad.org>,
        jgunthorpe@obsidianresearch.com, san@rosetechnology.dk, hs@denx.de,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rtc-linux@googlegroups.com" <rtc-linux@googlegroups.com>,
        Sverdlin Alexander <alexander.sverdlin@nsn.com>
Subject: Re: [PATCH v4 2/2] rtc: ds1307: add trickle charger device tree
 binding.
Message-ID: <20140909141155.GG21342@fi-ourus-dhcp00977.emea.nsn-net.net>
References: <20140909103832.GA338@fi-ourus-dhcp00977.emea.nsn-net.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140909103832.GA338@fi-ourus-dhcp00977.emea.nsn-net.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-purgate-type: clean
X-purgate-Ad: Categorized by eleven eXpurgate (R) http://www.eleven.de
X-purgate: clean
X-purgate: This mail is considered clean (visit http://www.eleven.de for further information)
X-purgate-size: 286
X-purgate-ID: 151667::1410268061-00002A30-7226E794/0/0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 09, 2014 at 01:38:39PM +0300, Matti Vaittinen wrote:
> +	diode = of_property_read_bool(client->dev.of_node, "diode-connected");

Please ignore this patch. I've accidentally sent the wrong version!
Sorry, I will send the correct one as soon as possible.

Br.
Matti

