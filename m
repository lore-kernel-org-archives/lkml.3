Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754631Ab3FFUWh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 16:22:37 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52622 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753340Ab3FFUWg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 16:22:36 -0400
Date: Thu, 6 Jun 2013 13:22:35 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Ferruh Yigit <fery@cypress.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, ttdrivers@cypress.com,
        Javier Martinez Canillas <javier@dowhile0.org>,
        Henrik Rydberg <rydberg@euromail.se>,
        Simon Budig <simon.budig@kernelconcepts.de>,
        Alexander Shiyan <shc_work@mail.ru>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Shawn Landden <shawnlandden@gmail.com>,
        Ashish Jangam <ashish.jangam@kpitcummins.com>,
        Olivier Sobrie <olivier@sobrie.be>, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org
Subject: Re: [PATCH v3 2/4] Input: cyttsp4 - Core driver for Cypress TMA4XX
 touchscreen devices
Message-ID: <20130606202235.GC18075@kroah.com>
References: <1370338484-26573-1-git-send-email-fery@cypress.com>
 <1370338484-26573-3-git-send-email-fery@cypress.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370338484-26573-3-git-send-email-fery@cypress.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 04, 2013 at 12:34:42PM +0300, Ferruh Yigit wrote:
> Cypress TrueTouch(tm) Standard Product controllers,
> Generetion4 devices, Core driver.
> 
> Core driver is interface between host and TTSP controller and processes
> data sent by controller.
> 
> Responsibilities of module are IRQ handling, reading system information
> registers and sending multi-touch protocol type B events.
> 
> Signed-off-by: Ferruh Yigit <fery@cypress.com>

Very nice job from the previous versions I've seen, this driver has come
a long way.

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
