Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751500AbaKFSMt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 13:12:49 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:56068 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750970AbaKFSMq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 13:12:46 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 104.193.169.186
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19DJHS3rNP1pXrr5pDkOSRc
Date: Thu, 6 Nov 2014 10:11:49 -0800
From: Tony Lindgren <tony@atomide.com>
To: Masanari Iida <standby24x7@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux@arm.linux.org.uk,
        linux-omap@vger.kernel.org, nm@ti.com
Subject: Re: [PATCH/v2] ARM: OMAP2: Remove unnecessary KERN_* in
 omap_phy_internal.c
Message-ID: <20141106181149.GA31454@atomide.com>
References: <20141006162151.GA21908@kahuna>
 <1412691376-7895-1-git-send-email-standby24x7@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1412691376-7895-1-git-send-email-standby24x7@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Masanari Iida <standby24x7@gmail.com> [141007 07:17]:
> This patch remove unnecessary KERN_INFO and KERN_ERR from omap_phy_internal.c.
> Add pr_fmt. 

Applying into omap-for-v3.19/fixes-not-urgent thanks.

Tony
