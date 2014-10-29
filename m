Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934163AbaJ2PmJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 11:42:09 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43983 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934099AbaJ2PmC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 11:42:02 -0400
Date: Wed, 29 Oct 2014 16:47:25 +0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: rtl8192e: from bus specific dma api to dma api
Message-ID: <20141029084725.GB18675@kroah.com>
References: <1413968086-15451-1-git-send-email-sudipm.mukherjee@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1413968086-15451-1-git-send-email-sudipm.mukherjee@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 22, 2014 at 02:24:46PM +0530, Sudip Mukherjee wrote:
> we should be using DMA API rather than using bus specific DMA API.

Why?

> converted the occurrence of pci_map_*() to dma_map_*(),
> and at the same time used the dma_mapping_error().	  

Trailing whitespace :(

What have you used to test this change?

thanks,

greg k-h
