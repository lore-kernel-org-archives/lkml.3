Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752285AbaCFRjG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 12:39:06 -0500
Received: from merlin.infradead.org ([205.233.59.134]:33186 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751673AbaCFRjE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 12:39:04 -0500
Message-ID: <5318B2B5.4030609@infradead.org>
Date: Thu, 06 Mar 2014 09:39:01 -0800
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org
CC: linux-kernel@vger.kernel.org, J Keerthy <j-keerthy@ti.com>,
        Samuel Ortiz <sameo@linux.intel.com>, lee.jones@linaro.org
Subject: Re: linux-next: Tree for Mar 6 (mfd/tps65218)
References: <20140306194821.3715d0b6212cc10415374a68@canb.auug.org.au>
In-Reply-To: <20140306194821.3715d0b6212cc10415374a68@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/06/2014 12:48 AM, Stephen Rothwell wrote:
> Hi all,
> 
> There may be build failures in this tree due to the percpu changes in the
> akpm tree.
> 
> This tree fails (more than usual) the powerpc allyesconfig build.
> 
> Changes since 20140305:
> 

In linux-next-20140305 and -20140306:

ERROR: "regmap_del_irq_chip" [drivers/mfd/tps65218.ko] undefined!

when CONFIG_REGMAP_IRQ is not enabled.


Driver's kconfig needs to select REGMAP_IRQ ?


-- 
~Randy
