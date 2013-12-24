Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752687Ab3LXOfH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Dec 2013 09:35:07 -0500
Received: from plane.gmane.org ([80.91.229.3]:54686 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752232Ab3LXOfF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Dec 2013 09:35:05 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Gene Anderson <gwa@cox.net>
Subject: Re: [PATCHv5] dmaengine: Add support for BCM2835
Date: Tue, 24 Dec 2013 14:31:31 +0000 (UTC)
Message-ID: <loom.20131224T151818-230@post.gmane.org>
References: <52864BBC.7000506@koalo.de> <1384537403.14845.131.camel@smile> <20131115175155.GQ16735@n2100.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: sea.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 68.111.221.21 (Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_1) AppleWebKit/537.73.11 (KHTML, like Gecko) Version/7.0.1 Safari/537.73.11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Group:

This is a request to augment with comments the 
DREQ explanation in the Broadcom BCM2835 
pdf on page 61 regarding DMA peripheral 
mapping.  Specifically, how to identify a pin on the 26 
pin 
header to use for DMA reads.  More specifically, 
if a clock signal, 
like GPCLK0 is output to the peripheral device 
(like an A/D converter) how we specify PERMAP in the 
DMA TI register.  Your users would be infinitely grateful.

thank you, 


