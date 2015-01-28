Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758191AbbA1AKl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 19:10:41 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:39790 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754708AbbA1AKk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 19:10:40 -0500
X-Sasl-enc: fYzzAhZh3jqgPQ4DiUO5WkXwJBkMRHkQWu/CuyftEi1i 1422403839
Date: Tue, 27 Jan 2015 16:10:38 -0800
From: Greg KH <greg@kroah.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        David Vrabel <david.vrabel@citrix.com>, xen-devel@lists.xensource.com,
        catalin.marinas@arm.com, Ian Campbell <ian.campbell@citrix.com>
Subject: Re: backport a4dba130891271084344c12537731542ec77cb85 to 3.16+
Message-ID: <20150128001038.GB17677@kroah.com>
References: <alpine.DEB.2.02.1501121704380.3058@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1501121704380.3058@kaball.uk.xensource.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 12, 2015 at 06:09:33PM +0000, Stefano Stabellini wrote:
> Hi all,
> I would like to request a backport of the following commit:
> 
> 
> commit a4dba130891271084344c12537731542ec77cb85
> Author: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> Date:   Fri Nov 21 11:07:39 2014 +0000
> 
>     xen/arm/arm64: introduce xen_arch_need_swiotlb
> 
> 
> to stable trees from 3.16 onward (3.16 included).
> 
> 
> The commit needs to be slightly modified because is_device_dma_coherent
> is not available on kernels < 3.19, so I just removed the call,
> thus assuming that the device is not coherent on arm (slower but safe):

A diff of a diff is hard to apply, please send the reworked patch in a
format that I can apply it in.

thanks,

greg k-h
