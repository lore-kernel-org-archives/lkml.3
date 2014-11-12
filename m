Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753060AbaKLPWP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 10:22:15 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:47525 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752620AbaKLPWN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 10:22:13 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 104.193.169.186
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+9fuGTFM1T+O6Plv8AwOj9
Date: Wed, 12 Nov 2014 07:21:32 -0800
From: Tony Lindgren <tony@atomide.com>
To: Johan Hovold <johan@kernel.org>
Cc: Paul Walmsley <paul@pwsan.com>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: OMAP2+: clock: remove unused function prototype
Message-ID: <20141112152132.GE26481@atomide.com>
References: <1415721364-25749-1-git-send-email-johan@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415721364-25749-1-git-send-email-johan@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Johan Hovold <johan@kernel.org> [141111 07:58]:
> Remove unused function prototype that was left by commit 149c09d3a61d
> ("ARM: AM33xx: remove old clock data and link in new clock init code")
> which removed the definition.

Applying into omap-for-v3.19/fixes-not-urgent thanks.

Tony
