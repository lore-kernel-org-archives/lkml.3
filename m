Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936665Ab3DJU06 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 16:26:58 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:15743 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932803Ab3DJU05 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 16:26:57 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/dpqrl/xgyl5XRGNUkbiMc
Date: Wed, 10 Apr 2013 13:26:53 -0700
From: Tony Lindgren <tony@atomide.com>
To: Paul Walmsley <paul@pwsan.com>
Cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Kishon Vijay Abraham I <kishon@ti.com>, rnayak@ti.com,
        b-cousson@ti.com, linux@arm.linux.org.uk, Keerthy <j-keerthy@ti.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] ARM: OMAP4: hwmod data: make
 'ocp2scp_usb_phy_phy_48m" as the main clock (fwd)
Message-ID: <20130410202653.GN10155@atomide.com>
References: <alpine.DEB.2.00.1304101941550.25123@utopia.booyaka.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1304101941550.25123@utopia.booyaka.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Paul Walmsley <paul@pwsan.com> [130410 12:48]:
> 
> Hi Tony,
> 
> could you send this one upstream for v3.9-rc fixes?  Should prevent 
> a MUSB regression in v3.9, mostly due to my own incompetence.

Thanks will do, applying into omap-for-v3.9-rc6/fixes.

Regards,

Tony
