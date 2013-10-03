Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754659Ab3JCSP0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 14:15:26 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:38241 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754150Ab3JCSPY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 14:15:24 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19D2fZWLVi35ZrFZGbSSYKD
Date: Thu, 3 Oct 2013 11:15:19 -0700
From: Tony Lindgren <tony@atomide.com>
To: Michael Opdenacker <michael.opdenacker@free-electrons.com>
Cc: linux@arm.linux.org.uk, khilman@deeprootsystems.com,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: OMAP: remove deprecated IRQF_DISABLED
Message-ID: <20131003181519.GR8949@atomide.com>
References: <1378538365-7353-1-git-send-email-michael.opdenacker@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1378538365-7353-1-git-send-email-michael.opdenacker@free-electrons.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Michael Opdenacker <michael.opdenacker@free-electrons.com> [130907 00:27]:
> This patch proposes to remove the IRQF_DISABLED flag from OMAP code
> It's a NOOP since 2.6.35, and will be removed one day.

Thanks, applying into omap-for-v3.13/fixes-not-urgent.

Tony
