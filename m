Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752071Ab3CAIAg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 03:00:36 -0500
Received: from mga11.intel.com ([192.55.52.93]:65047 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750779Ab3CAIAf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 03:00:35 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,760,1355126400"; 
   d="scan'208";a="297627101"
Date: Fri, 1 Mar 2013 10:00:30 +0200
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
To: Jason Cooper <jason@lakedaemon.net>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        thomas.petazzoni@free-electrons.com, iwamatsu@nigauri.org,
        linux-kernel@vger.kernel.org, yrl.pp-manager.tt@hitachi.com,
        linux-arm-kernel@lists.infradead.org, alan@linux.intel.com
Subject: Re: [BUG][arm-soc] kernel panic in boot on Openblocks with the
 latest kernel
Message-ID: <20130301080030.GD5688@xps8300>
References: <512F3BDA.6000208@hitachi.com>
 <20130228113419.GB5688@xps8300>
 <20130228142930.GQ23237@titan.lakedaemon.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130228142930.GQ23237@titan.lakedaemon.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jason,

On Thu, Feb 28, 2013 at 09:29:30AM -0500, Jason Cooper wrote:
> If you have a moment, could you put this into a formal patch and send to
> lakml?  If I could Gregory and Masami's Tested-by's on that, I'll queue
> it up for -rc1/2.

OK, I'll prepare the patch. I thought that Gregory was going to create
a patch for this.

Br,

-- 
heikki
