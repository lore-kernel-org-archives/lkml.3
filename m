Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755827AbaFWQPJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 12:15:09 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:50914 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755420AbaFWQPH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 12:15:07 -0400
Date: Mon, 23 Jun 2014 12:14:55 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        Christopher Harrer <charrer@alacritech.com>,
        Lior Dotan <liodot@gmail.com>,
        Forest Bond <forest@alittletooquiet.net>
Subject: Re: [PATCH 20/22] staging: Use pci_zalloc_consistent
Message-ID: <20140623161455.GA20288@kroah.com>
References: <cover.1403530604.git.joe@perches.com>
 <39c296d08cd5cf8e3ea1607b213a4e30494e92f2.1403530604.git.joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <39c296d08cd5cf8e3ea1607b213a4e30494e92f2.1403530604.git.joe@perches.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 23, 2014 at 06:41:48AM -0700, Joe Perches wrote:
> Remove the now unnecessary memset too.
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  drivers/staging/rtl8192e/rtl8192e/rtl_core.c | 15 ++++-------
>  drivers/staging/rtl8192ee/pci.c              | 37 +++++++++----------------
>  drivers/staging/rtl8821ae/pci.c              | 36 +++++++++----------------
>  drivers/staging/slicoss/slicoss.c            |  9 +++----
>  drivers/staging/vt6655/device_main.c         | 40 +++++++++-------------------
>  5 files changed, 44 insertions(+), 93 deletions(-)

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
