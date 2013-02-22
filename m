Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757912Ab3BVQSy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 11:18:54 -0500
Received: from mail-pa0-f48.google.com ([209.85.220.48]:52232 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757653Ab3BVQSx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 11:18:53 -0500
Date: Fri, 22 Feb 2013 08:19:30 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: linux-kernel@vger.kernel.org, JBeulich@suse.com
Subject: Re: Put git commit 51ac8893a7a51b196501164e645583bf78138699 on the
 stable tree please
Message-ID: <20130222161930.GA27694@kroah.com>
References: <20130222154644.GB8809@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130222154644.GB8809@phenom.dumpdata.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 22, 2013 at 10:46:45AM -0500, Konrad Rzeszutek Wilk wrote:
> Hey Greg,
> 
> Please put git commit 51ac8893a7a51b196501164e645583bf78138699
> commit 51ac8893a7a51b196501164e645583bf78138699
> Author: Jan Beulich <jbeulich@suse.com>
> Date:   Wed Feb 6 10:30:38 2013 -0500
> 
>     xen-pciback: rate limit error messages from xen_pcibk_enable_msi{,x}()
> 
> on the stable tree please. It is an security errata fix and should
> have had the CC: stable@vger.kernel.org but did not.

Thanks, what stable kernel releases should it be queued up for?

And, in the future, always send this to stable@vger.kernel.org, not to
me and lkml, the other stable kernel maintainers will want to know this.

greg k-h
