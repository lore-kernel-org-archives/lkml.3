Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754698AbaGOBfa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 21:35:30 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36757 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753393AbaGOBf2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 21:35:28 -0400
Date: Mon, 14 Jul 2014 18:40:00 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Chen Gang <gang.chen.5i5j@gmail.com>
Cc: devel@driverdev.osuosl.org, oleg.drokin@intel.com, paf@cray.com,
        andreas.dilger@intel.com, Andriy_Skulysh@xyratex.com,
        bergwolf@gmail.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        denis.pithon@gmail.com
Subject: Re: [PATCH v2] drivers: staging: lustre: Use 'force_die' instead of
 'die' to avoid compiling issue
Message-ID: <20140715014000.GA7849@kroah.com>
References: <53C3C611.3020804@gmail.com>
 <53C3C73F.3080906@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53C3C73F.3080906@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 14, 2014 at 08:04:15PM +0800, Chen Gang wrote:
> 
> For drivers/staging/lustre/lustre/include/lustre_sec.h:391:
> 
>  - staging tree: use '\t   ' between 'die' and '('.
> 
>  - linux-next tree: use '   ' between 'die' and '('.
> 
> So the patch made under linux-next tree, can not apply to staging-next
> or staging tree.

It seems to work just fine here, I don't see a problem...

thanks,

greg k-h
