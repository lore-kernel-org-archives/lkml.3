Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754292Ab3H1RBu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 13:01:50 -0400
Received: from mga09.intel.com ([134.134.136.24]:6605 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752962Ab3H1RBt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 13:01:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,976,1367996400"; 
   d="scan'208";a="369841622"
Date: Wed, 28 Aug 2013 10:01:37 -0700
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: Kumar Gaurav <kumargauravgupta3@gmail.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>, gregkh@linuxfoundation.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH v3] xHCI: Fixing xhci_readl definition and function call
Message-ID: <20130828170137.GB26483@xanatos>
References: <1377482937-7486-1-git-send-email-kumargauravgupta3@gmail.com>
 <20130828071304.GO6329@mwanda>
 <521E1292.5060709@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <521E1292.5060709@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 28, 2013 at 08:39:06PM +0530, Kumar Gaurav wrote:
> On Wednesday 28 August 2013 12:43 PM, Dan Carpenter wrote:
> >On Mon, Aug 26, 2013 at 07:38:57AM +0530, Kumar Gaurav wrote:
> I've started cloning linux-next and as it's not applying on
> linux-next, I'll try it on linux-next (once i cloned it)  and will
> send again.

Yeah, this doesn't apply against Greg's usb-next tree, so I can't take
it.  If you're sending non-bug fixes in, you need to base your patches
against that tree, or linux-next.

Sarah Sharp
