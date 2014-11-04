Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752301AbaKDIJZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 03:09:25 -0500
Received: from mail-ie0-f176.google.com ([209.85.223.176]:55785 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751867AbaKDIJW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 03:09:22 -0500
Date: Tue, 4 Nov 2014 08:09:17 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Subject: Re: linux-next: build failure after merge of the mfd tree
Message-ID: <20141104080917.GC17577@x1>
References: <20141104164005.1a45ad46@canb.auug.org.au>
 <1415087669.2389.7.camel@AMDC1943>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1415087669.2389.7.camel@AMDC1943>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 04 Nov 2014, Krzysztof Kozlowski wrote:
> On wto, 2014-11-04 at 16:40 +1100, Stephen Rothwell wrote:
> > 
> > After merging the mfd tree, today's linux-next build (powerpc allyesconfig)
> > failed like this:

[Crash, bang, wallop]

> > And so on ...
> > 
> > Caused by commit 9d5f4c2c748e ("mfd: max77686/802: Remove support for
> > board files") from the mfd tree.
> > 
> > I reverted that commit for today.
> 
> The commit depends on other patches from a set which hadn't been
> applied. Please drop it.

It is done!

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
