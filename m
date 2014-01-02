Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751823AbaABObu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 09:31:50 -0500
Received: from charlotte.tuxdriver.com ([70.61.120.58]:42294 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751172AbaABObs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 09:31:48 -0500
Date: Thu, 2 Jan 2014 09:31:35 -0500
From: Neil Horman <nhorman@tuxdriver.com>
To: David Miller <davem@davemloft.net>
Cc: linux-sctp@vger.kernel.org, vyasevich@gmail.com,
        gregkh@linuxfoundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 0/2] sctp: Consolidate and ratelimit deprecation
 warnings
Message-ID: <20140102143135.GA7526@hmsreliant.think-freely.org>
References: <1387205049-22752-1-git-send-email-nhorman@tuxdriver.com>
 <1387805383-21500-1-git-send-email-nhorman@tuxdriver.com>
 <20131231.140000.463004971089550957.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131231.140000.463004971089550957.davem@davemloft.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Score: -2.9 (--)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 31, 2013 at 02:00:00PM -0500, David Miller wrote:
> From: Neil Horman <nhorman@tuxdriver.com>
> Date: Mon, 23 Dec 2013 08:29:41 -0500
> 
> > The SCTP protocol has several deprecation warnings in its setsockopt path that
> > can be triggered by unprivlidged users.  Since these are not ratelimited, we can
> > spam the logs quite easily here.  Since these are all deprecation warnings, and
> > that type of warning isn't uncommon in the rest of the kernel, lets make a
> > common pr_warn_deprecated macro to produce somewhat generalized ratelimited
> > deprecation warnings easily
> > 
> > Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
> 
> Series applied, thanks Neil.
> 
> Please consider Ben's suggestion to provide the offending command string
> in the log output.
> 
Of course, I'll take care of it this week after I dig through all the holiday
email.
Neil

