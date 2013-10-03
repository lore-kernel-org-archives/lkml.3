Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754649Ab3JCSFw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 14:05:52 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:11345 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753893Ab3JCSFu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 14:05:50 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/+SiTt4yF2SbXTpYwuk8DX
Date: Thu, 3 Oct 2013 11:05:46 -0700
From: Tony Lindgren <tony@atomide.com>
To: Suman Anna <s-anna@ti.com>
Cc: Ohad Ben-Cohen <ohad@wizery.com>, Benoit Cousson <bcousson@baylibre.com>,
        Kumar Gala <galak@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH 1/2] hwspinlock/omap: add support for dt nodes
Message-ID: <20131003180546.GP8949@atomide.com>
References: <1378230767-54931-1-git-send-email-s-anna@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1378230767-54931-1-git-send-email-s-anna@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Suman Anna <s-anna@ti.com> [130903 11:00]:
> HwSpinlock IP is present only on OMAP4 and other newer SoCs,
> which are all device-tree boot only. This patch adds the
> base support for parsing the DT nodes, and removes the code
> dealing with the traditional platform device instantiation.

Great, this should be safe for Ohad to queue:

Acked-by: Tony Lindgren <tony@atomide.com>
