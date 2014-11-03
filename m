Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750999AbaKDAAf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 19:00:35 -0500
Received: from mga01.intel.com ([192.55.52.88]:22384 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750762AbaKDAAe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 19:00:34 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,310,1413270000"; 
   d="scan'208";a="625886492"
Date: Mon, 3 Nov 2014 15:47:54 -0800
From: steph <stephanie.s.wallick@intel.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        "Sean O. Stalley" <sean.stalley@intel.com>
Subject: Re: [PATCH 01/10] added media agnostic (MA) USB HCD driver
Message-ID: <20141103234753.GB8890@steph-desktop>
References: <1415047377-3139-1-git-send-email-stephanie.s.wallick@intel.com>
 <1415047377-3139-2-git-send-email-stephanie.s.wallick@intel.com>
 <20141103211816.GA7379@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141103211816.GA7379@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 03, 2014 at 01:18:16PM -0800, Greg KH wrote:
> On Mon, Nov 03, 2014 at 12:42:48PM -0800, Stephanie Wallick wrote:
> > +#define DEBUG
> 
> I doubt you want this in the driver enabled by default :(
> 

Thank you for catching, will remove in the next patch version.
