Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755979Ab3I3SHd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 14:07:33 -0400
Received: from top.free-electrons.com ([176.31.233.9]:55382 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755924Ab3I3SHc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 14:07:32 -0400
Date: Mon, 30 Sep 2013 20:07:21 +0200
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: bhelgaas@google.com, benh@kernel.crashing.org, daniel.price@gmail.com,
        thierry.reding@gmail.com, linux-kernel@vger.kernel.org,
        jason@lakedaemon.net, x86@kernel.org
Subject: Re: Build (x86, i386, non-SMP) breaks due to commit
 ebd97be635bff43239f391a49c78b98818c589fe (PCI: remove ARCH_SUPPORTS_MSI
 kconfig option
Message-ID: <20130930200721.4aed1e40@skate>
In-Reply-To: <20130930171849.GW3106@phenom.dumpdata.com>
References: <20130930171849.GW3106@phenom.dumpdata.com>
Organization: Free Electrons
X-Mailer: Claws Mail 3.9.1 (GTK+ 2.24.17; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Konrad Rzeszutek Wilk,

On Mon, 30 Sep 2013 13:18:49 -0400, Konrad Rzeszutek Wilk wrote:

> git bisect tells me that
> 
> git commit ebd97be635bff43239f391a49c78b98818c589fe is the first bad commit
> commit ebd97be635bff43239f391a49c78b98818c589fe
> Author: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
> Date:   Fri Aug 9 22:27:07 2013 +0200
> 
>     PCI: remove ARCH_SUPPORTS_MSI kconfig option
>     
> 
> When I try to build under i386, with make defconfig + # CONFIG_SMP is not set
> I end up with:

Thanks for reporting, I'll have a look tomorrow morning and get back to
you with a patch.

Thanks!

Thomas
-- 
Thomas Petazzoni, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
