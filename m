Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932203AbaLJOwq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 09:52:46 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:52397 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932154AbaLJOwo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 09:52:44 -0500
Date: Wed, 10 Dec 2014 09:52:41 -0500
From: Greg KH <gregkh@linuxfoundation.org>
To: atull@opensource.altera.com
Cc: jgunthorpe@obsidianresearch.com, hpa@zytor.com, monstr@monstr.eu,
        michal.simek@xilinx.com, rdunlap@infradead.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        pantelis.antoniou@konsulko.com, robh+dt@kernel.org,
        grant.likely@linaro.org, iws@ovro.caltech.edu,
        linux-doc@vger.kernel.org, pavel@denx.de, broonie@kernel.org,
        philip@balister.org, rubini@gnudd.com, s.trumtrar@pengutronix.de,
        jason@lakedaemon.net, kyle.teske@ni.com, nico@linaro.org, balbi@ti.com,
        m.chehab@samsung.com, davidb@codeaurora.org, rob@landley.net,
        davem@davemloft.net, cesarb@cesarb.net, sameo@linux.intel.com,
        akpm@linux-foundation.org, linus.walleij@linaro.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        delicious.quinoa@gmail.com, dinguyen@opensource.altera.com,
        yvanderv@opensource.altera.com
Subject: Re: [PATCH v4 0/6] FPGA Manager Framework
Message-ID: <20141210145241.GB17393@kroah.com>
References: <1418156090-23578-1-git-send-email-atull@opensource.altera.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1418156090-23578-1-git-send-email-atull@opensource.altera.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 09, 2014 at 02:14:44PM -0600, atull@opensource.altera.com wrote:
> From: Alan Tull <atull@opensource.altera.com>
> 
> Improvements in this v3 and v4:

Due to the review comments here, and all of the kbuild issues found,
please just work on a v5 series that I can apply after 3.19-rc1 is out.
I'm dropping this series from my queue now because of those issues.

thanks,

greg k-h
