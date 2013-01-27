Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756947Ab3A0X4v (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2013 18:56:51 -0500
Received: from mga02.intel.com ([134.134.136.20]:1559 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754171Ab3A0X4t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2013 18:56:49 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,547,1355126400"; 
   d="scan'208";a="253319705"
Date: Mon, 28 Jan 2013 00:56:50 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com
Subject: Re: [PATCH 06/10] mfd: arizona: Allow customisation of microphone
 detection levels
Message-ID: <20130127235650.GV1174@sortiz-mobl>
References: <1359259652-8565-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <1359259652-8565-6-git-send-email-broonie@opensource.wolfsonmicro.com>
 <20130127094425.GB32135@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130127094425.GB32135@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Sun, Jan 27, 2013 at 05:44:34PM +0800, Mark Brown wrote:
> On Sun, Jan 27, 2013 at 12:07:28PM +0800, Mark Brown wrote:
> > The microphone detection levels for Arizona parts can be customised.
> > Allow this to be done via platform data, the values chosen will depend
> > on the system design and determined in discussion with Wolfson.
> 
> Hrm, actually - since this isn't applied and I have a more flexible
> version to follow shortly (integrated into extcon rather than MFD) can
> you please not apply this?  
Sure, I'll skip it when I'll start my for-next patch merge (this week).

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
