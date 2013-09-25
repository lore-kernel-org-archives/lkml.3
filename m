Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754925Ab3IYXEd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 19:04:33 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:50868 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752428Ab3IYXEb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 19:04:31 -0400
Date: Wed, 25 Sep 2013 16:04:30 -0700
From: "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>
To: Jingoo Han <jg1.han@samsung.com>
Cc: linux-kernel@vger.kernel.org, "'Lidza Louina'" <lidza.louina@gmail.com>
Subject: Re: [PATCH 2/3] staging: dgnc: Remove casting the return value which
 is a void pointer
Message-ID: <20130925230430.GA4906@kroah.com>
References: <004301cead1b$e3272a00$a9757e00$%han@samsung.com>
 <004901cead1c$14c97680$3e5c6380$%han@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <004901cead1c$14c97680$3e5c6380$%han@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 09, 2013 at 02:18:55PM +0900, Jingoo Han wrote:
> Casting the return value which is a void pointer is redundant.
> The conversion from void pointer to any other pointer type is
> guaranteed by the C programming language.
> 
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> ---
>  drivers/staging/dgnc/dgnc_driver.c |    4 ++--
>  drivers/staging/dgnc/dgnc_sysfs.c  |   22 +++++++++++-----------
>  2 files changed, 13 insertions(+), 13 deletions(-)

No longer applies, please refresh against the latest linux-next release.

thanks,

greg k-h
