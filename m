Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755925Ab3ALAO5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 19:14:57 -0500
Received: from mail.kernel.org ([198.145.19.201]:39103 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755786Ab3ALAO4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 19:14:56 -0500
Date: Fri, 11 Jan 2013 16:14:54 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Venu Byravarasu <vbyravarasu@nvidia.com>, balbi@ti.com,
        sshtylyov@mvista.com, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH v3] usb: phy: use kzalloc to allocate struct tegra_usb_phy
Message-ID: <20130112001454.GC21909@kroah.com>
References: <1356071656-10052-1-git-send-email-vbyravarasu@nvidia.com>
 <50D4CC9F.6080000@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50D4CC9F.6080000@wwwdotorg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 21, 2012 at 01:54:55PM -0700, Stephen Warren wrote:
> On 12/20/2012 11:34 PM, Venu Byravarasu wrote:
> > Use kzalloc instead of kmalloc to allocate struct tegra_usb_phy.
> > This ensures that all function pointers in member u_phy are
> > initialized to NULL.
> 
> Seems fine to me. For the record, I'd like to take this through the
> Tegra tree with all the other Tegra-related USB patches in order to
> manage any dependencies, with the USB maintainers' Acks. Thanks.

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
