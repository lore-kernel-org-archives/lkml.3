Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754286Ab3FRIS0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 04:18:26 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:12450 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753603Ab3FRISY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 04:18:24 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19rhgKjIPrOIs9GIoXL864x
Date: Tue, 18 Jun 2013 01:18:20 -0700
From: Tony Lindgren <tony@atomide.com>
To: Aida Mynzhasova <aida.mynzhasova@skitlab.ru>
Cc: linux-omap@vger.kernel.org, linux@arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: OMAP2: TI81XX: id: Add cpu id for TI816x ES2.0
 and ES2.1
Message-ID: <20130618081819.GD5523@atomide.com>
References: <1369909261-23750-1-git-send-email-aida.mynzhasova@skitlab.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1369909261-23750-1-git-send-email-aida.mynzhasova@skitlab.ru>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Aida Mynzhasova <aida.mynzhasova@skitlab.ru> [130530 03:26]:
> Currently omap3xxx_check_revision() detects ES1.0 and ES1.1 only,
> this patch extends it by adding ES2.0 and ES2.1 versions support.

Thanks applying into omap-for-v3.11/soc.

Regards,

Tony
