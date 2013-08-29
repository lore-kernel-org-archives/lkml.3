Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756126Ab3H2WD2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 18:03:28 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37490 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753675Ab3H2WD1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 18:03:27 -0400
Date: Thu, 29 Aug 2013 15:05:50 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Martin =?utf-8?Q?MOKREJ=C5=A0?= <mmokrejs@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: 3.10.9: Oops at elf_core_dump()
Message-ID: <20130829220550.GA4486@kroah.com>
References: <521FC12A.9060302@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <521FC12A.9060302@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 29, 2013 at 11:46:18PM +0200, Martin MOKREJŠ wrote:
> Hi,
>   I just got this stacktrace. Not sure whom to send it, poking throu MAINTAINERS
> file and looking for ELF gave me nothing. ;-)
> 
> [105670.434336] BUG: unable to handle kernel NULL pointer dereference at           (null)
> [105670.434366] IP: [<ffffffff812f7b42>] strlen+0x2/0x20
> [105670.434385] PGD 18c8e5067 PUD 2b547e067 PMD 0 
> [105670.434401] Oops: 0000 [#1] SMP 
> [105670.434413] Modules linked in: iwldvm iwlwifi
> [105670.434432] CPU: 0 PID: 7497 Comm: emerge Not tainted 3.10.9-default-pciehp #8

Is this reproducable?

thanks,

greg k-h
