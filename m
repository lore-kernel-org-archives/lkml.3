Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754830Ab3IXWQ7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 18:16:59 -0400
Received: from webmail.solarflare.com ([12.187.104.25]:58648 "EHLO
	webmail.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754741Ab3IXWQ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 18:16:58 -0400
Message-ID: <1380061012.2736.57.camel@bwh-desktop.uk.level5networks.com>
Subject: Re: [PATCH 02/10] intel: Remove extern from function prototypes
From: Ben Hutchings <bhutchings@solarflare.com>
To: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
CC: Joe Perches <joe@perches.com>, <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        "Bruce Allan" <bruce.w.allan@intel.com>,
        Carolyn Wyborny <carolyn.wyborny@intel.com>,
        Don Skidmore <donald.c.skidmore@intel.com>,
        Greg Rose <gregory.v.rose@intel.com>,
        Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>,
        Alex Duyck <alexander.h.duyck@intel.com>,
        John Ronciak <john.ronciak@intel.com>,
        Tushar Dave <tushar.n.dave@intel.com>,
        <e1000-devel@lists.sourceforge.net>, <linux-kernel@vger.kernel.org>
Date: Tue, 24 Sep 2013 23:16:52 +0100
In-Reply-To: <1380060449.2189.6.camel@jtkirshe-mobl>
References: <cover.1380056108.git.joe@perches.com>
	 <5ccc921af41a862fe969809228f029035f851502.1380056108.git.joe@perches.com>
	 <1380060449.2189.6.camel@jtkirshe-mobl>
Organization: Solarflare
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.137]
X-TM-AS-Product-Ver: SMEX-10.0.0.1412-7.000.1014-20170.005
X-TM-AS-Result: No--22.273400-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-09-24 at 15:07 -0700, Jeff Kirsher wrote:
> On Tue, 2013-09-24 at 14:09 -0700, Joe Perches wrote:
> > There are a mix of function prototypes with and without extern
> > in the kernel sources.  Standardize on not using extern for
> > function prototypes.
> > 
> > Function prototypes don't need to be written with extern.
> > extern is assumed by the compiler.  Its use is as unnecessary as
> > using auto to declare automatic/local variables in a block.
> 
> So you are able to confirm that all compilers make this assumption
> correctly?  The initial reason for using extern was because not all
> compilers made the assumption or made it correctly.

You are probably thinking of global variables, where declarations
without either 'extern' or an initialiser might or might not be treated
as 'common'.  On function declarations, 'extern' really is redundant.

Ben.

-- 
Ben Hutchings, Staff Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

