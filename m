Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751310AbaKYSpE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 13:45:04 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:48886 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750878AbaKYSpC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 13:45:02 -0500
Date: Tue, 25 Nov 2014 10:45:01 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Richard Hendershot <rshendershot@mchsi.com>,
        Borislav Petkov <bp@suse.de>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        David Vrabel <david.vrabel@citrix.com>
Subject: Re: [PATCH 3.17 100/141] x86, microcode: Fix accessing dis_ucode_ldr
 on 32-bit
Message-ID: <20141125184501.GA3461@kroah.com>
References: <20141119205150.700188369@linuxfoundation.org>
 <20141119205153.916605840@linuxfoundation.org>
 <5474C67A.7040200@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5474C67A.7040200@oracle.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 25, 2014 at 01:12:10PM -0500, Boris Ostrovsky wrote:
> On 11/19/2014 03:52 PM, Greg Kroah-Hartman wrote:
> >3.17-stable review patch.  If anyone has any objections, please let me know.
> 
> 
> This breaks PV on Xen.

Does that mean it is also broken in Linus's tree?  If so, please fix it
there.  If not, is there some other patch I am missing for 3.17-stable
to resolve this?

thanks,

greg k-h
