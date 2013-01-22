Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756106Ab3AVVak (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 16:30:40 -0500
Received: from mail-da0-f43.google.com ([209.85.210.43]:41920 "EHLO
	mail-da0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752512Ab3AVVai (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 16:30:38 -0500
Date: Tue, 22 Jan 2013 13:30:30 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] lib: devres: Fix build breakage
Message-ID: <20130122213030.GA5285@kroah.com>
References: <1358889886-8502-1-git-send-email-thierry.reding@avionic-design.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1358889886-8502-1-git-send-email-thierry.reding@avionic-design.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 22, 2013 at 10:24:46PM +0100, Thierry Reding wrote:
> The ERR_PTR() and IS_ERR() macros used by the devm_ioremap_resource()
> function are defined in the linux/err.h header. On ARM this seems to be
> pulled in by one of the other headers but the build fails at least on
> OpenRISC.
> 
> Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>

You forgot to put a "reported-by:" field in here, which I've now done
for you.  Please be more considerate in the future.

thanks,

greg k-h
