Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754619AbaFPONi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 10:13:38 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:60527 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753280AbaFPONg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 10:13:36 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 99.127.230.128
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18NulIPL/SLdACXGjtpmNjM
Date: Mon, 16 Jun 2014 07:13:32 -0700
From: Tony Lindgren <tony@atomide.com>
To: Tero Kristo <t-kristo@ti.com>
Cc: Peter Ujfalusi <peter.ujfalusi@ti.com>, mturquette@linaro.org,
        grant.likely@linaro.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-doc@vger.kernel.org, robh+dt@kernel.org, bcousson@baylibre.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 4/4] ARM: DTS: dra7/dra7xx-clocks: ATL related changes
Message-ID: <20140616141331.GK17845@atomide.com>
References: <1399458048-28213-1-git-send-email-peter.ujfalusi@ti.com>
 <1399458048-28213-5-git-send-email-peter.ujfalusi@ti.com>
 <539EF8C6.1080207@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <539EF8C6.1080207@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Tero Kristo <t-kristo@ti.com> [140616 07:03]:
> On 05/07/2014 01:20 PM, Peter Ujfalusi wrote:
> >Modify the clock nodes for the ATL clocks to use the ATL clock driver to
> >handle them.
> >
> >Add the ATL device node at the same time for DRA7.
> >
> >Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
> 
> This patch missed the merge window due to long dependency chain, however
> Tony promised to pull this with rc-fixes. So, for that purpose:
> 
> Acked-by: Tero Kristo <t-kristo@ti.com>

Thanks applying into omap-for-v3.16/fixes.

Regards,

Tony
