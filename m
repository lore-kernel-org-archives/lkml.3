Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758428Ab3KZXqv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 18:46:51 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:61342 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756653Ab3KZXqu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 18:46:50 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18uul8VU0LwLZ2HwrXbcEBG
Date: Tue, 26 Nov 2013 15:46:43 -0800
From: Tony Lindgren <tony@atomide.com>
To: Eunbong Song <eunb.song@samsung.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, nsekhar@ti.com,
        davinci-linux-open-source@linux.davincidsp.com, dwmw2@infradead.org
Subject: Re: [PATCH] ARM: Kill CONFIG_MTD_PARTITIONS
Message-ID: <20131126234643.GU26766@atomide.com>
References: <17954130.75631385509274999.JavaMail.weblogic@epml11>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <17954130.75631385509274999.JavaMail.weblogic@epml11>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Eunbong Song <eunb.song@samsung.com> [131126 15:42]:
> 
> This patch removes CONFIG_MTD_PARTITIONS in config files for ARM.
> Because CONFIG_MTD_PARTITIONS was removed by commit 6a8a98b22b10f1560d5f90aded4a54234b9b2724.

Missing Signed-off-by?

This patch is probably best sent to the arm-soc maintainers so
they can pick it up. For the omap changes:

Acked-by: Tony Lindgren <tony@atomide.com> 
 
