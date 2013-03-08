Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933256Ab3CHV1D (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 16:27:03 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:62206 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932413Ab3CHV1A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 16:27:00 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 72.84.113.162
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/ZmG/Iso8b9miVInkTGU7hj0wTu+DJ9Xc=
Date: Fri, 8 Mar 2013 16:26:49 -0500
From: Jason Cooper <jason@lakedaemon.net>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Russell King <linux@arm.linux.org.uk>,
        Jean-Francois Moine <moinejf@free.fr>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Subject: Re: [PATCH v2] ARM: dove: drop "select COMMON_CLK_DOVE"
Message-ID: <20130308212649.GS23237@titan.lakedaemon.net>
References: <1362476098.16460.65.camel@x61.thuisdomein>
 <51363A9E.6090507@gmail.com>
 <1362514637.16460.117.camel@x61.thuisdomein>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1362514637.16460.117.camel@x61.thuisdomein>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 05, 2013 at 09:17:17PM +0100, Paul Bolle wrote:
> Commit 5b03df9ace680d7cdd34a69dfd85ca5f74159d18 ("ARM: dove: switch to
> DT clock providers") added "select COMMON_CLK_DOVE" to Marvell Dove's
> Kconfig entry. But there's no Kconfig symbol COMMON_CLK_DOVE, which
> makes this select statement a nop. It's probably a leftover of some
> experimental code that never hit mainline. Drop it.
> 
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> ---
> 0) v2: Sebastian suggested to drop this select entirely.
> 
> 1) Still untested.
> 
>  arch/arm/Kconfig | 1 -
>  1 file changed, 1 deletion(-)

Applied to mvebu/fixes

thx,

Jason.
