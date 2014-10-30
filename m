Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760007AbaJ3QcI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 12:32:08 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:35849 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759266AbaJ3QcF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 12:32:05 -0400
Date: Thu, 30 Oct 2014 09:30:53 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Jeff Epler <jepler@unpythonic.net>
Cc: Bjorn Helgaas <bhelgaas@google.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: incompatible pci sysfs change since 3.12 (5136b2da770d)
Message-ID: <20141030163053.GB22250@kroah.com>
References: <20141030002258.GA59253@unpythonic.net>
 <20141030003657.GA5487@kroah.com>
 <20141030011615.GB59253@unpythonic.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141030011615.GB59253@unpythonic.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 29, 2014 at 08:16:15PM -0500, Jeff Epler wrote:
> On Wed, Oct 29, 2014 at 05:36:57PM -0700, Greg Kroah-Hartman wrote:
> > Ugh, that's my fault, I made a typo and should not have renamed the
> > sysfs file, very sorry about that.
> > 
> > I'll work on making up a patch to fix this and get it into the stable
> > kernels so that you don't have to have a work-around for very long.
> 
> Thank you!  I appreciate your quick response.

I've now sent a patch that should fix this.  If you could verify it, I'd
appreciate it.

thanks,

greg k-h
