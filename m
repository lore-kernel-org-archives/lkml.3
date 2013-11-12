Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754825Ab3KLHc5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 02:32:57 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:54020 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754143Ab3KLHcf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 02:32:35 -0500
Date: Mon, 11 Nov 2013 16:24:26 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Ondrej Zary <linux@rainbow-software.org>
Cc: Aldo Iljazi <mail@aldo.io>, marek.belisko@gmail.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: ft1000: fixed a few styling issues
Message-ID: <20131112002426.GA7660@kroah.com>
References: <1383567322-22879-1-git-send-email-mail@aldo.io>
 <201311041332.21209.linux@rainbow-software.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201311041332.21209.linux@rainbow-software.org>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 04, 2013 at 01:32:20PM +0100, Ondrej Zary wrote:
> 
> Shouldn't this be removed from the code, converted to a binary file and loaded 
> by the kernel firmware loader instead?

Yes it should, please send patches to do so.

And don't quote the whole firmware blob when responding to patches where
you just add 2 lines at the bottom of the email...

thanks,

greg k-h
