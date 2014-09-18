Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932300AbaIRQyu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 12:54:50 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:27210 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932081AbaIRQys (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 12:54:48 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 99.127.230.128
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+NH5XG3OA2Ajomw46zsbRF
Date: Thu, 18 Sep 2014 09:54:24 -0700
From: Tony Lindgren <tony@atomide.com>
To: Joe Perches <joe@perches.com>
Cc: linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>,
        =?utf-8?Q?Beno=C3=AEt?= Cousson <bcousson@baylibre.com>,
        Paul Walmsley <paul@pwsan.com>,
        Kevin Hilman <khilman@deeprootsystems.com>, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/8] arm: mach-omap2: Convert pr_warning to pr_warn
Message-ID: <20140918165424.GH14505@atomide.com>
References: <cover.1410632834.git.joe@perches.com>
 <1f7bd81d1a391defa61327143d258e6cda23ead6.1410632835.git.joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1f7bd81d1a391defa61327143d258e6cda23ead6.1410632835.git.joe@perches.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Joe Perches <joe@perches.com> [140913 11:32]:
> Use the more common pr_warn.
> 
> Other miscellanea:
> 
> o Realign arguments

Thanks I'll apply this into omap-for-v3.18/cleanup.

Regards,

Tony
