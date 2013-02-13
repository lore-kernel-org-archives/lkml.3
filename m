Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760504Ab3BMUU5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 15:20:57 -0500
Received: from mail-da0-f53.google.com ([209.85.210.53]:58257 "EHLO
	mail-da0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751439Ab3BMUUz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 15:20:55 -0500
Date: Wed, 13 Feb 2013 12:20:51 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Michail Kurochkin <michail.kurachkin@promwad.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Initial commit of TDM core
Message-ID: <20130213202051.GA7585@kroah.com>
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

<snip>

Interesting, care to actually Cc: the proper people, and put the needed
information in the body of the email?

> ---
>  drivers/staging/Kconfig        |    4 +
>  drivers/staging/Makefile       |    4 +-
>  drivers/staging/tdm/Kconfig    |   38 ++
>  drivers/staging/tdm/Makefile   |   19 +
>  drivers/staging/tdm/tdm_core.c |  826 ++++++++++++++++++++++++++++++++++++++++
>  include/linux/tdm/tdm.h        |  292 ++++++++++++++

Sorry, all staging drivers need to be self-contained within their
drivers/staging/ directory, so this needs to be changed.

thanks,

greg k-h
