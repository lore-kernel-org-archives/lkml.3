Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759033Ab3JNVEX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 17:04:23 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43259 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759015Ab3JNVEU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 17:04:20 -0400
Date: Mon, 14 Oct 2013 14:04:19 -0700
From: greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Vineet Gupta <Vineet.Gupta1@synopsys.com>
Cc: "stable@vger.kernel.org" <stable@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: ARC fixes backport for stable 3.10
Message-ID: <20131014210419.GA12262@kroah.com>
References: <525BA41B.4000109@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <525BA41B.4000109@synopsys.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 14, 2013 at 01:28:19PM +0530, Vineet Gupta wrote:
> Hi Greg,
> 
> Can you please apply the following mainline commits to your queue for next 3.10
> stable, in that order.
> 
> e11a3d063c18 ARC: SMP failed to boot due to missing IVT setup

I don't know what this git commit id is, should that be
c3567f8a359b7917dcffa442301f88ed0a75211f?  If so, I've now applied it,
if not, please let me know.

thanks,

greg k-h
