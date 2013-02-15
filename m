Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752035Ab3BOTs4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 14:48:56 -0500
Received: from sauhun.de ([89.238.76.85]:57914 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751917Ab3BOTsy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 14:48:54 -0500
Date: Fri, 15 Feb 2013 20:48:44 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, "Bill E. Brown" <bill.e.brown@intel.com>,
        Jean Delvare <khali@linux-fr.org>,
        Seth Heasley <seth.heasley@intel.com>,
        Neil Horman <nhorman@tuxdriver.com>, linux-i2c@vger.kernel.org
Subject: Re: [PATCH -next] i2c: fix i2c-ismt.c printk format warning
Message-ID: <20130215194844.GE4351@the-dreams.de>
References: <20130215184255.5ba8a085004f4aadb9faf82c@canb.auug.org.au>
 <511E83BC.3050007@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <511E83BC.3050007@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 15, 2013 at 10:51:40AM -0800, Randy Dunlap wrote:
> From: Randy Dunlap <rdunlap@infradead.org>
> 
> Fix printk format warning.  dma_addr_t can be 32-bit or 64-bit,
> so cast it to long long for printing.  This also matches the
> printk format specifier that is already used.
> 
> drivers/i2c/busses/i2c-ismt.c:532:3: warning: format '%llX' expects argument of type 'long long unsigned int', but argument 4 has type 'dma_addr_t' [-Wformat]
> 
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>

Thanks, applied to next.

