Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755547Ab3BDVnw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 16:43:52 -0500
Received: from mail-vb0-f52.google.com ([209.85.212.52]:49770 "EHLO
	mail-vb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754448Ab3BDVnu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 16:43:50 -0500
Date: Mon, 4 Feb 2013 13:43:44 -0800
From: Tejun Heo <tj@kernel.org>
To: "Marciniszyn, Mike" <mike.marciniszyn@intel.com>
Cc: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rusty@rustcorp.com.au" <rusty@rustcorp.com.au>,
        "bfields@fieldses.org" <bfields@fieldses.org>,
        "skinsbursky@parallels.com" <skinsbursky@parallels.com>,
        "ebiederm@xmission.com" <ebiederm@xmission.com>,
        "jmorris@namei.org" <jmorris@namei.org>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        "roland@kernel.org" <roland@kernel.org>
Subject: Re: [PATCHSET] idr: implement idr_alloc() and convert existing users
Message-ID: <20130204214344.GI27963@mtj.dyndns.org>
References: <1359854463-2538-1-git-send-email-tj@kernel.org>
 <20130204191720.GW27963@mtj.dyndns.org>
 <32E1700B9017364D9B60AED9960492BC0D58DF86@FMSMSX108.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <32E1700B9017364D9B60AED9960492BC0D58DF86@FMSMSX108.amr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 04, 2013 at 08:08:47PM +0000, Marciniszyn, Mike wrote:
> > It looks like this kernel won't compile with CONFIG_HOTPLUG_MEMORY set to
> > 'y'
> 
> Turning off the CONFIG_HOTPLUG_MEMORY allowed the build to work.
> 
> At least for me, basic IB functionality works with the latest repo.
> 
> The ipath and qib patches look ok, but we usually use IB/<module> vs. infiniband/<module>.

Ok, renaming the patches.

Thanks.

-- 
tejun
