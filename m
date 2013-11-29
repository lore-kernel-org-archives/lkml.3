Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754774Ab3K2L70 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 06:59:26 -0500
Received: from mga11.intel.com ([192.55.52.93]:46114 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753168Ab3K2L7Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 06:59:24 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,797,1378882800"; 
   d="scan'208";a="441997679"
Date: Fri, 29 Nov 2013 13:59:20 +0200
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
To: Alexandre Courbot <acourbot@nvidia.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Rhyland Klein <rklein@nvidia.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] gpio: better lookup method for platform GPIOs
Message-ID: <20131129115920.GC3942@xps8300>
References: <1385628388-23827-1-git-send-email-acourbot@nvidia.com>
 <20131129115748.GB3942@xps8300>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131129115748.GB3942@xps8300>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 29, 2013 at 01:57:48PM +0200, Heikki Krogerus wrote:
> > -	gpiod_add_table(gpios_table, ARRAY_SIZE(gpios_table));
> > +	gpiod_add_lookup_table(&gpios_table);
> 
> Remove "&" from the above.

Sorry, ignore that :).

-- 
heikki
