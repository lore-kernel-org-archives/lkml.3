Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753469Ab3HBPLO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 11:11:14 -0400
Received: from mga09.intel.com ([134.134.136.24]:45621 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751357Ab3HBPLM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 11:11:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,802,1367996400"; 
   d="scan'208";a="356298272"
Message-ID: <1375456553.14869.340.camel@sauron.fi.intel.com>
Subject: Re: [PATCH] mtd: remove obsolete JEDEC mapping drivers
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Paul Bolle <pebolle@tiscali.nl>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
        linux-mtd@lists.infradead.org
Date: Fri, 02 Aug 2013 18:15:53 +0300
In-Reply-To: <1374749192.29835.48.camel@x61.thuisdomein>
References: <1368456039.1350.53.camel@x61.thuisdomein>
	 <1374749192.29835.48.camel@x61.thuisdomein>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-07-25 at 12:46 +0200, Paul Bolle wrote:
> On Mon, 2013-05-13 at 16:40 +0200, Paul Bolle wrote:
> > JEDEC device support was removed in v2.6.22. (It had been marked as
> > BROKEN (indirectly) since at least v2.6.12.)
> > 
> > When it was removed the two JEDEC mapping drivers that depended on it
> > should have been removed too. Do so now.
> > 
> > Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> > ---
> > 0) Untested.
> > 
> > 1) These two [seem] to have been missed in Artem's recent cleaning up
> > effort. Or is a comparable patch queued somewhere?
> 
> Did anyone had a chance to look at this patch? Or has this code already
> been removed?

Pushed to l2-mtd.git, thanks!

-- 
Best Regards,
Artem Bityutskiy

