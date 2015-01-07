Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752299AbbAGKZ0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 05:25:26 -0500
Received: from mga01.intel.com ([192.55.52.88]:5986 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751069AbbAGKZY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 05:25:24 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,713,1413270000"; 
   d="scan'208";a="647493210"
Date: Wed, 7 Jan 2015 12:25:20 +0200
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] pinctrl: intel: Pass CONFIG_DEBUG_PINCTRL to drivers
Message-ID: <20150107102520.GO1386@lahna.fi.intel.com>
References: <1417689170-41627-1-git-send-email-mika.westerberg@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417689170-41627-1-git-send-email-mika.westerberg@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 04, 2014 at 12:32:49PM +0200, Mika Westerberg wrote:
> If the user has selected CONFIG_DEBUG_PINCTRL=y make sure that Intel
> pinctrl drivers will be compiled with that option as well.
> 
> Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>

Gentle ping on these two.
