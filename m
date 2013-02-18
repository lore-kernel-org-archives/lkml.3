Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756513Ab3BRD7T (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2013 22:59:19 -0500
Received: from mga02.intel.com ([134.134.136.20]:35886 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754741Ab3BRD7R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2013 22:59:17 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,683,1355126400"; 
   d="scan'208";a="286975454"
Date: Mon, 18 Feb 2013 11:07:23 -0500
From: Youquan Song <youquan.song@linux.intel.com>
To: Libor Pechacek <lpechacek@suse.cz>
Cc: Youquan Song <youquan.song@intel.com>, htejun@gmail.com,
        ming.lei@canonical.com, sshtylyov@mvista.com,
        linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
        seth.heasley@intel.com, jlee@suse.com, james.d.ralston@intel.com,
        stable@vger.kernel.org, Youquan Song <youquan.song@linux.intel.com>
Subject: Re: [PATCH v2] ata: Fix DVD not dectected at some Haswell platforms
Message-ID: <20130218160723.GA1749@linux-youquan.bj.intel.com>
References: <1359731982-1390-1-git-send-email-youquan.song@intel.com> <20130213083242.GD1106@fm.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130213083242.GD1106@fm.suse.cz>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> As to my understanding Sergei did not suggest citing the whole commit message.
> I also find the numerous references to Sandy Bridge confusing as this is a fix
> for Lynx Point chipset.
> 
> How about rephrasing the commit message in a way similar to the following one?
> ------8<-----
> We've hit a problem with DVD not recognized on Haswell Desktop platform which
> includes Lynx Point 2-port SATA controller.  This quirk patch disables 32bit
> PIO on the controller in IDE mode.
> ------>8-----
Thanks Libor!
I have updated the comments and sent out a v3 patch out to LKML. 


> > +		.flags		= PIIX_SATA_FLAGS | PIIX_FLAG_SIDPR | PIIX_FLAG_PIO16,
> 
> The line might be worth splitting as it's over 80 characters.
> 
> Otherwise the patch looks OK to me.
> 
Also change it in v3 patch.

Thanks
-Youquan
