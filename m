Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752790AbaEUQJA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 12:09:00 -0400
Received: from top.free-electrons.com ([176.31.233.9]:40961 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752677AbaEUQI6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 12:08:58 -0400
Date: Wed, 21 May 2014 13:08:18 -0300
From: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
To: Roger Quadros <rogerq@ti.com>
Cc: tony@atomide.com, computersforpeace@gmail.com, pekon@ti.com,
        robertcnelson@gmail.com, jg1.han@samsung.com, dwmw2@infradead.org,
        javier@dowhile0.org, nsekhar@ti.com, linux-omap@vger.kernel.org,
        linux-mtd@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 00/16] OMAP: GPMC: Restructure OMAP GPMC driver (NAND)
Message-ID: <20140521160818.GA1150@arch.cereza>
References: <1400671264-10702-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1400671264-10702-1-git-send-email-rogerq@ti.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Roger,

On 21 May 02:20 PM, Roger Quadros wrote:
> 
> For DT boot:
> - The GPMC controller node should have a chip select (CS) node for each used
>   chip select. The CS node must have a child device node for each device
>   attached to that chip select. Properties for that child are GPMC agnostic.
> 
>   i.e.
> 	gpmc {
> 		cs0 {
> 			nand0 {
> 			}
> 		};
> 
> 		cs1 {
> 			nor0 {
> 			}
> 		}
> 		...
> 	};
> 

While I agree that the GPMC driver is a bit messy, I'm not sure it's possible
to go through such a complete devicetree binding re-design (breaking backwards
compatibility) now that the binding is already in production.

AFAIK, TI's SDK 7.0 is released, with a v3.8.x kernel which uses this GPMC
binding. And then you have the ISEE board too, using this binding.

Also, what's the problem with the current devicetree binding (not that I'm fan
of it)?
-- 
Ezequiel García, Free Electrons
Embedded Linux, Kernel and Android Engineering
http://free-electrons.com
