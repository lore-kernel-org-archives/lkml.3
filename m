Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752907AbaINV5j (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2014 17:57:39 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44000 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752832AbaINV5i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2014 17:57:38 -0400
Date: Sun, 14 Sep 2014 14:57:37 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Mark S <mstanovich15@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Octavian Purdila <octavian.purdila@intel.com>,
        Jun Tian <jun.j.tian@intel.com>, Alan Cox <alan@linux.intel.com>
Subject: Re: 3.15 Regression Due to goldfish bus Commit
Message-ID: <20140914215737.GA945@kroah.com>
References: <CAPC5HRoW4pdMhBrJfQ40ZnJoon+zCRtAnZzzgEExw4ks=Trr2g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPC5HRoW4pdMhBrJfQ40ZnJoon+zCRtAnZzzgEExw4ks=Trr2g@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 14, 2014 at 05:38:55PM -0400, Mark S wrote:
> Commit c1bc97f8f498a2bfab63ceef761fb0e88ef7c065 causes a gateway x86 laptop,
> booting from a usb device, to hang before the kernel completes booting. The
> offending commit was found using git bisect. Reverting the commit fixes the
> problem on 3.16.2.
> 
> The error resulting in the hang may not be a concern since the goldfish option
> is not needed and should probably not be selected. I'm mentioning this problem
> just in case it is unexpected behavior and it is worth fixing. Maybe the
> goldfish option should not be selectable for a similar configuration as mine?

There should be some other type of run-time option to not have this code
run if it is found to not be running on the goldfish virtual machine.

Anyone know how to do that?

thanks,

greg k-h
