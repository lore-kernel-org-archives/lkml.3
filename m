Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752161AbaJBQeV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 12:34:21 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52481 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751365AbaJBQeU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 12:34:20 -0400
Date: Thu, 2 Oct 2014 09:34:19 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Jerry Stralko <gerb.stralko@gmail.com>
Cc: gulsah.1004@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] stagging : rtl8821ae : Fixed sparse warning
Message-ID: <20141002163419.GA13585@kroah.com>
References: <5421FDBE.1080706@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5421FDBE.1080706@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 23, 2014 at 07:09:50PM -0400, Jerry Stralko wrote:
> Symbol was not declared. Should it be static?
> 
> Signed-off-by: Jerry Stralko 
> ---
>  drivers/staging/rtl8821ae/base.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

This driver is no longer in the kernel tree :(
