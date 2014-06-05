Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752960AbaFERHb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 13:07:31 -0400
Received: from merlin.infradead.org ([205.233.59.134]:42607 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752111AbaFERH1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 13:07:27 -0400
Message-ID: <5390A3CC.2020309@infradead.org>
Date: Thu, 05 Jun 2014 10:07:24 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org
CC: LKML <linux-kernel@vger.kernel.org>, Chris Ball <chris@printf.net>,
        Ulf Hansson <ulf.hansson@linaro.org>, linux-mmc@vger.kernel.org,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: linux-next: Tree for Jun 5 (mmc/host/usdhi6ro10.c)
References: <20140605192853.0344d9d3@canb.auug.org.au>
In-Reply-To: <20140605192853.0344d9d3@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/05/2014 02:28 AM, Stephen Rothwell wrote:
> Hi all,
> 
> The powerpc allyesconfig is again broken more than usual.
> 
> Our build server is down today, so this linux-next will not get the
> usual builds done, sorry.
> 
> Changes since 20140604:
> 
> 
> The mmc tree lost its build failure.

but has a bunch of printk format warnings on x86_64:


../drivers/mmc/host/usdhi6rol0.c:359:2: warning: format '%zd' expects argument of type 'signed size_t', but argument 4 has type 'unsigned int' [-Wformat]
../drivers/mmc/host/usdhi6rol0.c:359:2: warning: format '%zd' expects argument of type 'signed size_t', but argument 5 has type 'unsigned int' [-Wformat]
../drivers/mmc/host/usdhi6rol0.c:462:2: warning: format '%u' expects argument of type 'unsigned int', but argument 7 has type 'size_t' [-Wformat]
../drivers/mmc/host/usdhi6rol0.c:491:3: warning: format '%zd' expects argument of type 'signed size_t', but argument 4 has type 'unsigned int' [-Wformat]
../drivers/mmc/host/usdhi6rol0.c:491:3: warning: format '%zd' expects argument of type 'signed size_t', but argument 5 has type 'unsigned int' [-Wformat]
../drivers/mmc/host/usdhi6rol0.c:898:2: warning: format '%x' expects argument of type 'unsigned int', but argument 9 has type 'size_t' [-Wformat]
../drivers/mmc/host/usdhi6rol0.c:1668:3: warning: format '%x' expects argument of type 'unsigned int', but argument 6 has type 'size_t' [-Wformat]


-- 
~Randy
