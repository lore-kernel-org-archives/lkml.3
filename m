Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754584AbaIKLZO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 07:25:14 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:44406 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754137AbaIKLZJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 07:25:09 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18z4AajkqS1XP6w9uhQvrRsSbeoYgpdoPA=
X-DKIM: OpenDKIM Filter v2.0.1 titan 3DC455DE5F4
Date: Thu, 11 Sep 2014 07:24:55 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Pavel Machek <pavel@ucw.cz>
Cc: kernel list <linux-kernel@vger.kernel.org>, matti.vaittinen@nsn.com,
        robh+dt@kernel.org, akpm@linux-foundation.org,
        ijc+devicetree@hellion.org.uk, a.zummo@towertech.it,
        linux@roeck-us.net
Subject: Re: rtc: bq32000: add trickle charger device tree binding
Message-ID: <20140911112455.GY30828@titan.lakedaemon.net>
References: <20140911104045.GA16478@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140911104045.GA16478@amd>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 11, 2014 at 12:40:45PM +0200, Pavel Machek wrote:
> BQ32000 have "trickle chargers".  Introduce a device tree
> binding for specifying the trickle charger configuration for that.
> 
> Signed-off-by: Pavel Machek <pavel@denx.de>

Reviewed-by: Jason Cooper <jason@lakedameon.net>

thx,

Jason.
