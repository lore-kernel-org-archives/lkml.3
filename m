Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753258AbaETNF7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 09:05:59 -0400
Received: from cantor2.suse.de ([195.135.220.15]:52329 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753110AbaETNF6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 09:05:58 -0400
Date: Tue, 20 May 2014 15:05:56 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Rogier Wolff <R.E.Wolff@bitwizard.nl>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Buffer cache not working.
Message-ID: <20140520130556.GA10945@dhcp22.suse.cz>
References: <20140514144632.GB7404@bitwizard.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140514144632.GB7404@bitwizard.nl>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 14-05-14 16:46:32, Rogier Wolff wrote:
[...]
> Kernel: from Ubuntu 14.04, 3.13.0-19-generic

The kernel is 64b right?

> 32-bit userspace
> 16Gb RAM installed. 
> Disks: 3x 3T in RAID5
> 
> ganglia shows the server memory graph as follows: 
> http://prive.bitwizard.nl/server_mem.png

This shows that the memory usage didn't go over 5G. That is suspicious.
Is this a NUMA machine? Is it possible that zone_reclaim_mode is enabled
(cat /proc/sys/vm/zone_reclaim_mode)?
 
> All other computers have a "nice" filled graph there.
> 
> So, is there a bug in my kernel or am I missing an important tuning
> parameter?
> 
> 
> 	Roger. 
> 
> -- 
> ** R.E.Wolff@BitWizard.nl ** http://www.BitWizard.nl/ ** +31-15-2600998 **
> **    Delftechpark 26 2628 XH  Delft, The Netherlands. KVK: 27239233    **
> *-- BitWizard writes Linux device drivers for any device you may have! --*
> The plan was simple, like my brother-in-law Phil. But unlike
> Phil, this plan just might work.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Michal Hocko
SUSE Labs
