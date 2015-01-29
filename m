Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753401AbbA2Oa7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 09:30:59 -0500
Received: from mga01.intel.com ([192.55.52.88]:61719 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751553AbbA2Oa6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 09:30:58 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,486,1418112000"; 
   d="scan'208";a="678002040"
Date: Thu, 29 Jan 2015 16:30:53 +0200
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
To: Felipe Balbi <balbi@ti.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Baolu Lu <baolu.lu@linux.intel.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Kishon Vijay Abraham I <kishon@ti.com>
Subject: Re: [PATCH 8/8] phy: add driver for TI TUSB1210 ULPI PHY
Message-ID: <20150129143053.GC2570@kuha.fi.intel.com>
References: <1422025978-178336-1-git-send-email-heikki.krogerus@linux.intel.com>
 <1422025978-178336-9-git-send-email-heikki.krogerus@linux.intel.com>
 <20150129050951.GC9098@saruman.tx.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150129050951.GC9098@saruman.tx.rr.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Also, I was chatting in private with David and, apparently, there's a
> way to request for eye diagram data from BIOS straight. That's more
> in-line with what we would do for DT-based boots, passing that
> eye-diagram data as a DT attribute.
> 
> Care to comment ? If that's the case, I'd rather use that BIOS hook and
> remove ulpi_read() from probe().

I'm not familiar with such method. But if there is one, I'm not
against it. I need to check it.


Thanks,

-- 
heikki
