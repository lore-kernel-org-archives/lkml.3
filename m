Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753849Ab3CHT4B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 14:56:01 -0500
Received: from mho-04-ewr.mailhop.org ([204.13.248.74]:61760 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751136Ab3CHTz7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 14:55:59 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19ohS3Q7q/C6QPAJxUi8uLh
Date: Fri, 8 Mar 2013 11:55:55 -0800
From: Tony Lindgren <tony@atomide.com>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 10/10] ARM: smp: Remove local timer API
Message-ID: <20130308195555.GI11806@atomide.com>
References: <1362614646-24113-1-git-send-email-sboyd@codeaurora.org>
 <1362614646-24113-11-git-send-email-sboyd@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1362614646-24113-11-git-send-email-sboyd@codeaurora.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Stephen Boyd <sboyd@codeaurora.org> [130306 16:23]:
> There are no more users of this API, remove it.
> 
> Cc: Russell King <linux@arm.linux.org.uk>
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>

Acked-by: Tony Lindgren <tony@atomide.com>
