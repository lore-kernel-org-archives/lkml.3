Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756653Ab3GDLsM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 07:48:12 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:52288 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753359Ab3GDLsJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 07:48:09 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19W0XZqpSLQArqCpZyp7AF4
Date: Thu, 4 Jul 2013 04:48:05 -0700
From: Tony Lindgren <tony@atomide.com>
To: Kevin Hilman <khilman@linaro.org>
Cc: Thomas Meyer <thomas@m3y3r.de>, linux@arm.linux.org.uk,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: OMAP: Cocci spatch "ptr_ret.spatch"
Message-ID: <20130704114804.GF5523@atomide.com>
References: <1370079884.29224.16.camel@localhost.localdomain>
 <878v2qlwqp.fsf@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <878v2qlwqp.fsf@linaro.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Kevin Hilman <khilman@linaro.org> [130603 14:23]:
> Thomas Meyer <thomas@m3y3r.de> writes:
> 
> > Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
> 
> Could use a changelog, but otherwise
> 
> Acked-by: Kevin Hilman <khilman@linaro.org>

I've updated the patch to use subject as the changelog,
applying into omap-for-v3.11/fixes.

Tony
