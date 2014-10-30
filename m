Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758019AbaJ3BQT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 21:16:19 -0400
Received: from rrcs-76-79-27-186.west.biz.rr.com ([76.79.27.186]:27893 "EHLO
	rrcs-76-79-27-186.west.biz.rr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756618AbaJ3BQS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 21:16:18 -0400
Date: Wed, 29 Oct 2014 20:16:15 -0500
From: Jeff Epler <jepler@unpythonic.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: incompatible pci sysfs change since 3.12 (5136b2da770d)
Message-ID: <20141030011615.GB59253@unpythonic.net>
References: <20141030002258.GA59253@unpythonic.net>
 <20141030003657.GA5487@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141030003657.GA5487@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 29, 2014 at 05:36:57PM -0700, Greg Kroah-Hartman wrote:
> Ugh, that's my fault, I made a typo and should not have renamed the
> sysfs file, very sorry about that.
> 
> I'll work on making up a patch to fix this and get it into the stable
> kernels so that you don't have to have a work-around for very long.

Thank you!  I appreciate your quick response.

Jeff
