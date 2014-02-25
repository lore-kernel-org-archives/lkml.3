Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752750AbaBYLh6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 06:37:58 -0500
Received: from mga03.intel.com ([143.182.124.21]:60143 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751784AbaBYLh5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 06:37:57 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,539,1389772800"; 
   d="scan'208";a="413433354"
Date: Tue, 25 Feb 2014 17:07:53 +0530
From: Jenny Tc <jenny.tc@intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
        linux-kernel@vger.kernel.org, Anton Vorontsov <anton@enomsg.org>,
        luca@coelho.fi, Johannes Berg <johannes.berg@intel.com>
Subject: Re: [PATCH 3.14] power_supply: don't export power_supply_notifier
Message-ID: <20140225113753.GA20856@jenny-desktop>
References: <1392988768-16693-1-git-send-email-johannes@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392988768-16693-1-git-send-email-johannes@sipsolutions.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 21, 2014 at 02:19:28PM +0100, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> Since there are registration/unregistration functions and the
> invocation is in the core code, there's no need to export the
> notifier chain head, make it static instead.

This is a generic notifier which can be used outside power_supply_core.c
to post psy events as in patch
power_supply-Introduce-generic-psy-charging-driver.patch. So the notifier chain
need to be exported.
