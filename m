Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753435Ab3F2CiS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 22:38:18 -0400
Received: from mail.active-venture.com ([67.228.131.205]:63962 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751336Ab3F2CiQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 22:38:16 -0400
X-Originating-IP: 108.223.40.66
Date: Fri, 28 Jun 2013 19:38:23 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Pantelis Antoniou <panto@antoniou-consulting.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/6] Introducing Device Tree Overlays
Message-ID: <20130629023703.GA12849@roeck-us.net>
References: <1357327870-13615-1-git-send-email-panto@antoniou-consulting.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1357327870-13615-1-git-send-email-panto@antoniou-consulting.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 04, 2013 at 09:31:04PM +0200, Pantelis Antoniou wrote:
> The following patchset introduces Device Tree overlays, a method
> of dynamically altering the kernel's live Device Tree.
> 
> This patchset is against mainline as of Friday Jan 4 2013.
> (4956964 Merge tag 'driver-core-3.8-rc2' of \
>  	git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/driver-core)
> 
> Note that a separate patch for the DTC compiler has been posted and
> is required to compile the DTS files according to the documentation.
> The patch is "dtc: Dynamic symbols & fixup support"
> 
> An implementation patchset for a beaglebone cape loader will follow,
> but if you want to check out a working kernel for the beaglebone please
> pull from:
> 
> git://github.com/pantoniou/linux-bbxm.git branch not-capebus-v8
> 
> Pantelis Antoniou (6):
>   OF: Introduce device tree node flag helpers.
>   OF: export of_property_notify
>   OF: Export all DT proc update functions
>   OF: Introduce utility helper functions
>   OF: Introduce Device Tree resolve support.
>   OF: Introduce DT overlay support.
> 
Hi Pantelis,

do you have an update of this patchset ? I want to seriously start testing it.
Digging through your tree on github is a bit cumbersome, and I am not sure
if I got all patches. It would also be nice to get an update with all the
comments addressed.

Thanks,
Guenter
