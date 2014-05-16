Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932155AbaEPVN2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 17:13:28 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:31310 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753334AbaEPVN0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 17:13:26 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 99.127.230.128
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19PZILyJssIfPwfubiQDoq2
Date: Fri, 16 May 2014 14:13:21 -0700
From: Tony Lindgren <tony@atomide.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Russell King <linux@arm.linux.org.uk>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: OMAP: AM3517EVM: remove check for
 CONFIG_PANEL_SHARP_LQ043T1DG01
Message-ID: <20140516211321.GG12881@atomide.com>
References: <1400183692.11786.23.camel@x220>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1400183692.11786.23.camel@x220>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Paul Bolle <pebolle@tiscali.nl> [140515 12:55]:
> The Kconfig symbol PANEL_SHARP_LQ043T1DG01 was removed in v2.6.38. The
> check for CONFIG_PANEL_SHARP_LQ043T1DG01 and its MODULE variant has
> evaluated to false ever since. Remove that check.

Thanks applying into omap-for-v3.16/board.

Tony
