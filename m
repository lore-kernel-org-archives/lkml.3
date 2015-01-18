Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752209AbbARO1s (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2015 09:27:48 -0500
Received: from mga02.intel.com ([134.134.136.20]:5123 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751398AbbARO1p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2015 09:27:45 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,421,1418112000"; 
   d="scan'208";a="652832434"
Date: Sun, 18 Jan 2015 19:56:18 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Cc: dmaengine@vger.kernel.org,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Antoine =?iso-8859-1?Q?T=E9nart?= <antoine@free-electrons.com>,
        Russell King <linux@arm.linux.org.uk>, lars@metafoo.de
Subject: Re: [PATCH] dmaengine: Move dma_get_slave_caps() implementation to
 dmaengine.c
Message-ID: <20150118142618.GO15411@intel.com>
References: <1414531573-18807-11-git-send-email-maxime.ripard@free-electrons.com>
 <1414535458-21699-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1414535458-21699-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 29, 2014 at 12:30:58AM +0200, Laurent Pinchart wrote:
> The function is too big to be a static inline.
> 
Applied thanks

-- 
~Vinod

