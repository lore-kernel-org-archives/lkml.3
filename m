Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753062AbaKDRVX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 12:21:23 -0500
Received: from mail.csclub.uwaterloo.ca ([129.97.134.52]:50309 "EHLO
	mail.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751832AbaKDRVT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 12:21:19 -0500
From: "Lennart Sorensen" <lsorense@csclub.uwaterloo.ca>
Date: Tue, 4 Nov 2014 12:21:17 -0500
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        tony@atomide.com, balbi@ti.com, gregkh@linuxfoundation.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH 11/13] arm: dts: dra7: add DMA properties for UART
Message-ID: <20141104172117.GC24112@csclub.uwaterloo.ca>
References: <1412014009-13315-1-git-send-email-bigeasy@linutronix.de>
 <1412014009-13315-12-git-send-email-bigeasy@linutronix.de>
 <20141104170233.GB24112@csclub.uwaterloo.ca>
 <5459079D.7080703@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5459079D.7080703@linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 04, 2014 at 06:06:37PM +0100, Sebastian Andrzej Siewior wrote:
> On 11/04/2014 06:02 PM, Lennart Sorensen wrote:
> > 
> > According to the manual the DMA channels for UART7 to 10 are:
> > 
> > uart7:  144 145
> > uart8:  146 147
> > uart9:  148 149
> > uart10: 150 151
> > 
> > Might as well add those too.  We have uart 7 and 8 in use on our board
> > so I am about to go test it.
> 
> Mind sharing the manual with me? Mine does not mention DMA channels for
> UART7-10. If you are able to test 7+8 (and it works) could you please
> make patch which with for the remaining four devices?

Well the file I have is called AM572x_ES1.1_NDA_TRM_vT.pdf, so I am not
sure who I am allowed to share that file with.  Might be simpler to just
ask TI for the latest version.

How I hate NDAs.

-- 
Len Sorensen
