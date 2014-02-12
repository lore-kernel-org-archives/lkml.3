Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751880AbaBLJNh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 04:13:37 -0500
Received: from mga03.intel.com ([143.182.124.21]:37400 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751386AbaBLJNe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 04:13:34 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,831,1384329600"; 
   d="scan'208";a="473881263"
Date: Wed, 12 Feb 2014 11:21:08 +0200
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Peter Wu <lekensteyn@gmail.com>,
        Bastien Traverse <bastien.traverse@gmail.com>,
        linux-kernel@vger.kernel.org, francis.moro@gmail.com,
        linux-pm@vger.kernel.org
Subject: Re: 3.12: ethernet controller missing after resuming from suspend to
 RAM
Message-ID: <20140212092107.GA5018@intel.com>
References: <52F2CC7B.80406@gmail.com>
 <20140211104237.GE18029@intel.com>
 <8701691.z6Q6jDD18v@al>
 <1835578.EmLUpvTMQe@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1835578.EmLUpvTMQe@vostro.rjw.lan>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 12, 2014 at 12:58:07AM +0100, Rafael J. Wysocki wrote:
> Mika, I'll add a changelog to your patch and queue it up as a fix for 3.14.

Thanks Rafael.
