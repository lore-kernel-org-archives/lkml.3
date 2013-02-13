Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934240Ab3BMUWJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 15:22:09 -0500
Received: from mail-pa0-f51.google.com ([209.85.220.51]:35131 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934006Ab3BMUWI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 15:22:08 -0500
Date: Wed, 13 Feb 2013 12:21:54 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Michail Kurochkin <michail.kurachkin@promwad.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Initial commit of TDM core
Message-ID: <20130213202154.GB7585@kroah.com>
References: <20130213195851.D737134C6296@sp-git01-lo1.promwad.corp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130213195851.D737134C6296@sp-git01-lo1.promwad.corp>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 13, 2013 at 07:09:11PM +0300, Michail Kurochkin wrote:
> Signed-off-by: Michail Kurochkin <michail.kurachkin@promwad.com>
> ---
>  drivers/staging/Kconfig        |    4 +
>  drivers/staging/Makefile       |    4 +-
>  drivers/staging/tdm/Kconfig    |   38 ++
>  drivers/staging/tdm/Makefile   |   19 +
>  drivers/staging/tdm/tdm_core.c |  826 ++++++++++++++++++++++++++++++++++++++++
>  include/linux/tdm/tdm.h        |  292 ++++++++++++++
>  6 files changed, 1182 insertions(+), 1 deletions(-)

Also, I need a TODO file for all new drivers in the staging tree listing
what needs to be done to them in order to have them move out of the
staging tree.

thanks,

greg k-h
