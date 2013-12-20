Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753188Ab3LTXpt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 18:45:49 -0500
Received: from mga02.intel.com ([134.134.136.20]:2217 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751709Ab3LTXps (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 18:45:48 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,524,1384329600"; 
   d="scan'208";a="428076373"
Date: Fri, 20 Dec 2013 15:45:47 -0800
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: Denis Turischev <denis.turischev@compulab.co.il>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH v1] xhci: Switch Intel Lynx Point ports to EHCI on
 shutdown
Message-ID: <20131220234547.GC2835@xanatos>
References: <52B31EDA.60908@compulab.co.il>
 <52B327D5.3080805@compulab.co.il>
 <20131219182110.GC3573@xanatos>
 <52B41EC7.1070704@compulab.co.il>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52B41EC7.1070704@compulab.co.il>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 20, 2013 at 12:41:11PM +0200, Denis Turischev wrote:
> > Also, which kernel are you experiencing this issue on?  In 3.12, I
> > queued a separate patch to deal with spurious reboot issues on Lynx
> > Point:
> > 
> > commit 638298dc66ea36623dbc2757a24fc2c4ab41b016
> Sorry, I indeed tested not on the latest kernel version, Ubuntu 3.13-rc3 has this patch and it works
> for me.

What does "Ubuntu 3.13-rc3" mean?  Where did you get your kernel from?

Also, do you have an HP system, or is this a different vendor?

Sarah Sharp
