Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755454AbaLHMyz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 07:54:55 -0500
Received: from mail-qg0-f44.google.com ([209.85.192.44]:38768 "EHLO
	mail-qg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753211AbaLHMyx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 07:54:53 -0500
Date: Mon, 8 Dec 2014 12:54:47 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Mark Brown <broonie@kernel.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Laurentiu Palcu <laurentiu.palcu@intel.com>
Subject: Re: linux-next: build failure after merge of the spi tree
Message-ID: <20141208125447.GJ3951@x1>
References: <20141208230517.13ebfe4f@canb.auug.org.au>
 <20141208121342.GW11764@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20141208121342.GW11764@sirena.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 08 Dec 2014, Mark Brown wrote:

> On Mon, Dec 08, 2014 at 11:05:17PM +1100, Stephen Rothwell wrote:
> 
> > Caused by commit cf9e9c98fa8c ("spi: Add new driver for
> > STMicroelectronics' SPI Controller").
> 
> > To me COMPILE_TEST means "this builds everywhere, make sure it doesn't
> > break" ... not "lets set this and see if Stephen finds anything" :-)
> 
> > I reverted both commits for today.
> 
> I've dropped both from my tree too.

Patches re-sent without COMPILE_TEST support.

I will re-enable COMPILE_TEST when Will Deacon's patch to fix this
kind of nonsense lands.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
