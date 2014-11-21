Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757761AbaKUEHx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 23:07:53 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:50092 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751596AbaKUEHv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 23:07:51 -0500
Date: Thu, 20 Nov 2014 20:06:30 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Anjana Sasindran <anjanasasindran123@gmail.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging:skein: Fix trailing  whitespace error
Message-ID: <20141121040630.GB28757@kroah.com>
References: <1416526887-8566-1-git-send-email-anjanasasindran123@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1416526887-8566-1-git-send-email-anjanasasindran123@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 21, 2014 at 05:11:27AM +0530, Anjana Sasindran wrote:
> This patch fixes the checkpatch.pl error:
> 
> ERROR: trailing whitespace
> 
> Signed-off-by: Anjana Sasindran <anjanasasindran123@gmail.com>
> ---
>  arch/arm/boot/dts/include/dt-bindings   | 1 -
>  arch/metag/boot/dts/include/dt-bindings | 1 -
>  arch/mips/boot/dts/include/dt-bindings  | 1 -

What are these files doing in this patch?

I can't take this...

greg k-h
