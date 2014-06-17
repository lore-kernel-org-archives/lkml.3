Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932276AbaFQJvj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 05:51:39 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:57978 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932091AbaFQJvf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 05:51:35 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 99.127.230.128
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19AyFmABg5bShlzx28LEqgF
Date: Tue, 17 Jun 2014 02:51:33 -0700
From: Tony Lindgren <tony@atomide.com>
To: Roger Quadros <rogerq@ti.com>
Cc: dmitry.torokhov@gmail.com, rydberg@euromail.se, balbi@ti.com,
        dmurphy@ti.com, mugunthanvnm@ti.com, nsekhar@ti.com,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org
Subject: Re: [PATCH v7 0/5] Input: pixcir_i2c_ts: Add Type-B Multi-touch and
 DT support
Message-ID: <20140617095132.GR17845@atomide.com>
References: <1402997507-9736-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1402997507-9736-1-git-send-email-rogerq@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Roger Quadros <rogerq@ti.com> [140617 02:33]:
> Hi Dmitry,
> 
> These are the pending patches that didn't go through in the 3.16 merge window.
> Please queue them for -next. Thanks.
> 
> The series does the following
> - convert to Type-B multi touch protocol
> - support upto 5 fingers with hardware supplied tracking IDs
> - device tree support
> 
> Tony,
> 
> The last 2 patches fix the touch screen size property in the device tree since
> we now use the unified touch screen properties.

OK I acked those two pathes so Dmitry can take them too
when the driver changes get merged.

Regards,

Tony
