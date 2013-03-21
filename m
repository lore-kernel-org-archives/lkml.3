Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933337Ab3CUIrQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 04:47:16 -0400
Received: from mga11.intel.com ([192.55.52.93]:57032 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752057Ab3CUIrN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 04:47:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,884,1355126400"; 
   d="scan'208";a="309872418"
Date: Thu, 21 Mar 2013 10:47:07 +0200
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: linux-arm-kernel@lists.infradead.org, kevin@allwinnertech.com,
        sunny@allwinnertech.com, shuge@allwinnertech.com,
        linux-serial@vger.kernel.org,
        Emilio =?iso-8859-1?Q?L=F3pez?= <emilio@elopez.com.ar>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] serial: 8250_dw: add support for clk api
Message-ID: <20130321084707.GB2862@xps8300>
References: <1363689316-7847-2-git-send-email-maxime.ripard@free-electrons.com>
 <1363690369-8067-1-git-send-email-maxime.ripard@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1363690369-8067-1-git-send-email-maxime.ripard@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 19, 2013 at 11:52:49AM +0100, Maxime Ripard wrote:
> From: Emilio López <emilio@elopez.com.ar>
> 
> This commit implements support for using the clk api; this lets us use
> the "clocks" property with device tree, instead of having to use
> clock-frequency.
> 
> Signed-off-by: Emilio López <emilio@elopez.com.ar>

FWIW,

Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>

-- 
heikki
