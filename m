Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758471AbbA0OzY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 09:55:24 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57051 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752957AbbA0OzV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 09:55:21 -0500
Date: Tue, 27 Jan 2015 06:55:18 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Chunyan Zhang <chunyan.zhang@spreadtrum.com>, robh+dt@kernel.org,
        mark.rutland@arm.com, gnomes@lxorguk.ukuu.org.uk,
        peter@hurleysoftware.com, pawel.moll@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        grant.likely@linaro.org, jslaby@suse.cz, heiko@sntech.de,
        jason@lakedaemon.net, florian.vaussard@epfl.ch, andrew@lunn.ch,
        hytszk@gmail.com, antonynpavlov@gmail.com, shawn.guo@linaro.org,
        orsonzhai@gmail.com, geng.ren@spreadtrum.com,
        zhizhou.zhang@spreadtrum.com, lanqing.liu@spreadtrum.com,
        zhang.lyra@gmail.com, wei.qiao@spreadtrum.com,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org, linux-api@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v8 0/2] Add Spreadtrum SoC bindings and serial driver
 support
Message-ID: <20150127145518.GA32531@kroah.com>
References: <1422345407-10037-1-git-send-email-chunyan.zhang@spreadtrum.com>
 <2196748.ag4UzqF1Px@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2196748.ag4UzqF1Px@wuerfel>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 27, 2015 at 02:24:02PM +0100, Arnd Bergmann wrote:
> On Tuesday 27 January 2015 15:56:45 Chunyan Zhang wrote:
> > This patch-set split the last version, and addressed the review comments from
> > last version on serial driver code.
> > 
> > Changes from v7:
> > * Addressed review comments from Peter:
> >         - Initialized the stack local with zero in sprd_set_termios()
> >         - Used dev_get_drvdata() to get sprd_uart_port
> > 
> 
> Looks good to me, but you still have too many people on 'To', so Greg
> might be missing that you expect him to merge it.
> 
> Greg, if there are no further comments, can you take both patches through
> the tty git?

Will do, thanks.

greg k-h
