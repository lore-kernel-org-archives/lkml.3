Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757394AbaLJOyD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 09:54:03 -0500
Received: from 251.110.2.81.in-addr.arpa ([81.2.110.251]:36986 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753905AbaLJOyA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 09:54:00 -0500
Date: Wed, 10 Dec 2014 14:50:52 +0000
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: <atull@opensource.altera.com>
Cc: <gregkh@linuxfoundation.org>, <jgunthorpe@obsidianresearch.com>,
        <hpa@zytor.com>, <monstr@monstr.eu>, <michal.simek@xilinx.com>,
        <rdunlap@infradead.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <pantelis.antoniou@konsulko.com>,
        <robh+dt@kernel.org>, <grant.likely@linaro.org>,
        <iws@ovro.caltech.edu>, <linux-doc@vger.kernel.org>, <pavel@denx.de>,
        <broonie@kernel.org>, <philip@balister.org>, <rubini@gnudd.com>,
        <s.trumtrar@pengutronix.de>, <jason@lakedaemon.net>,
        <kyle.teske@ni.com>, <nico@linaro.org>, <balbi@ti.com>,
        <m.chehab@samsung.com>, <davidb@codeaurora.org>, <rob@landley.net>,
        <davem@davemloft.net>, <cesarb@cesarb.net>, <sameo@linux.intel.com>,
        <akpm@linux-foundation.org>, <linus.walleij@linaro.org>,
        <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <delicious.quinoa@gmail.com>, <dinguyen@opensource.altera.com>,
        <yvanderv@opensource.altera.com>
Subject: Re: [PATCH v4 4/6] fpga manager: add sysfs interface document
Message-ID: <20141210145052.56f0b880@lxorguk.ukuu.org.uk>
In-Reply-To: <1418156090-23578-5-git-send-email-atull@opensource.altera.com>
References: <1418156090-23578-1-git-send-email-atull@opensource.altera.com>
	<1418156090-23578-5-git-send-email-atull@opensource.altera.com>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.24; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 9 Dec 2014 14:14:48 -0600
> +Contact:	Alan Tull <atull@opensource.altera.com>
> +Description:	Read state of fpga framework state machine as a string.
> +		Valid states may vary by manufacturer; superset is:
> +		* unknown		= can't determine state
> +		* power_off		= FPGA power is off
> +		* power_up		= FPGA reports power is up
> +		* reset			= FPGA held in reset state
> +		* firmware_request	= firmware class request in progress
> +		* firmware_request_err	= firmware request failed
> +		* write_init		= FPGA being prepared for programming
> +		* write_init_err	= Error while preparing FPGA for
> +					  programming
> +		* write			= FPGA ready to receive image data
> +		* write_err		= Error while programming
> +		* write_complete	= Doing post programming steps
> +		* write_complete_err	= Error while doing post programming
> +		* operating		= FPGA is programmed and operating


How does this work as a security model?

I want to assign an FPGA resource to a specific end user. How do I do
that with a pile of sysfs nodes ?

