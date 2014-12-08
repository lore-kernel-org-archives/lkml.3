Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753933AbaLHTz5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 14:55:57 -0500
Received: from relay1.sgi.com ([192.48.180.66]:50660 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750980AbaLHTzz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 14:55:55 -0500
Date: Mon, 8 Dec 2014 13:55:53 -0600
From: Alex Thorlton <athorlton@sgi.com>
To: James Smart <james.smart@emulex.com>
Cc: Alex Thorlton <athorlton@sgi.com>,
        "Elliott, Robert (Server Storage)" <Elliott@hp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [BUG] kzalloc overflow in lpfc driver on 6k core system
Message-ID: <20141208195553.GB4182@sgi.com>
References: <20141202215810.GT4720@sgi.com>
 <94D0CD8314A33A4D9D801C0FE68B4029593EFC9E@G4W3202.americas.hpqcorp.net>
 <20141203160546.GA4720@sgi.com>
 <548363B5.1040909@emulex.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <548363B5.1040909@emulex.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 06, 2014 at 03:14:45PM -0500, James Smart wrote:
> Myself and several others here at Emulex maintain the code. The
> recommendations look fine.   Feel free to post something if you beat
> us to the work.

Great!  Thanks for letting me know, James.  I will probaby have some
time to look at this later this week.  Please let me know if somebody
over there gets around to looking at it - no need to have two groups
chasing the same issue :)

Thanks again!

- Alex
