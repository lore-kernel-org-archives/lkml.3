Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756917AbaFTQnK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 12:43:10 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59449 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752496AbaFTQnI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 12:43:08 -0400
Date: Fri, 20 Jun 2014 09:47:09 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Jim Davis <jim.epost@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-next <linux-next@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, andreas.noever@gmail.com
Subject: Re: randconfig build error with next-20140620, in
 drivers/thunderbolt/nhi.c
Message-ID: <20140620164709.GA5043@kroah.com>
References: <CA+r1ZhjD7qvOKedKAUGMmoVL1BPHW545O1QdxBCqQkvZNt9Npg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+r1ZhjD7qvOKedKAUGMmoVL1BPHW545O1QdxBCqQkvZNt9Npg@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 20, 2014 at 07:03:44AM -0700, Jim Davis wrote:
> Building with the attached random configuration file,
> 
> drivers/thunderbolt/nhi.c: In function ‘nhi_probe’:
> drivers/thunderbolt/nhi.c:541:2: error: implicit declaration of
> function ‘pcim_enable_device’ [-Werror=implicit-function-declaration]
>   res = pcim_enable_device(pdev);
>   ^
> drivers/thunderbolt/nhi.c:547:2: error: implicit declaration of
> function ‘pci_enable_msi’ [-Werror=implicit-function-declaration]
>   res = pci_enable_msi(pdev);
>   ^
> cc1: some warnings being treated as errors
> make[2]: *** [drivers/thunderbolt/nhi.o] Error 1

A patch was just sent to fix this, will be in the next linux-next
release, thanks.

greg k-h
