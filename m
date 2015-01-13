Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752830AbbAMSMD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 13:12:03 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:49517 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751190AbbAMSMB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 13:12:01 -0500
Date: Tue, 13 Jan 2015 10:11:59 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Jim Davis <jim.epost@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-next <linux-next@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, alan@linux.intel.com,
        linux-pcmcia@lists.infradead.org
Subject: Re: randconfig build error with next-20150113, in
 drivers/pcmcia/rsrc_pci.c
Message-ID: <20150113181159.GA15031@kroah.com>
References: <CA+r1ZhhATHDNKzk=T1aXimL8=pOa+92-D9RL7a18v+JT2UP_KQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+r1ZhhATHDNKzk=T1aXimL8=pOa+92-D9RL7a18v+JT2UP_KQ@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 13, 2015 at 11:08:30AM -0700, Jim Davis wrote:
> Building with the attached random configuration file,
> 
> drivers/pcmcia/rsrc_pci.c: In function ‘find_io_region’:
> drivers/pcmcia/rsrc_pci.c:40:2: error: implicit declaration of
> function ‘pci_bus_alloc_resource’
> [-Werror=implicit-function-declaration]
>   ret = pci_bus_alloc_resource(s->cb_dev->bus, res, num, 1,
>   ^
> drivers/pcmcia/rsrc_pci.c:40:40: error: dereferencing pointer to incomplete type
>   ret = pci_bus_alloc_resource(s->cb_dev->bus, res, num, 1,
>                                         ^
> drivers/pcmcia/rsrc_pci.c: In function ‘res_pci_find_mem’:
> drivers/pcmcia/rsrc_pci.c:144:40: error: dereferencing pointer to
> incomplete type
>   ret = pci_bus_alloc_resource(s->cb_dev->bus,
>                                         ^
> cc1: some warnings being treated as errors
> make[2]: *** [drivers/pcmcia/rsrc_pci.o] Error 1

I have a patch from Arnd to fix this that I'll queue up soon, thanks.

greg k-h
