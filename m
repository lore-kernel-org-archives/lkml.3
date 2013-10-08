Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756045Ab3JHS34 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 14:29:56 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:19385 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751775Ab3JHS3y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 14:29:54 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18dtah7Tn5Ror/wJlU76Dsl
Date: Tue, 8 Oct 2013 11:29:45 -0700
From: Tony Lindgren <tony@atomide.com>
To: joerg Reisenweber <joerg@openmoko.org>
Cc: Pali =?utf-8?B?Um9ow6Fy?= <pali.rohar@gmail.com>,
        Russell King <linux@arm.linux.org.uk>, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] RX-51: Add missing max_current to
 rx51_lp5523_led_config
Message-ID: <20131008182945.GI8313@atomide.com>
References: <1379541145-25934-1-git-send-email-pali.rohar@gmail.com>
 <201309200020.58671@pali>
 <201309231450.12171@pali>
 <201309231506.37942.joerg@openmoko.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201309231506.37942.joerg@openmoko.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* joerg Reisenweber <joerg@openmoko.org> [130923 06:14]:
> On Mon 23 September 2013 14:50:12 Pali Rohár wrote:
> > Hi Tony,
> > 
> > here is new version (v2) of patch which adding max_current values to rx51
> > board data. According to joerg safe value for max_current is 100 (10 mA).
> > 
> > 
> > RX-51: Add missing max_current to rx51_lp5523_led_config
> > 
> > File drivers/leds/leds-lp55xx-common.c refuse to change led_current sysfs
> > attribute if value is higher than max_current specified in board file. By
> > default global C variables are zero, so changing always failed. This patch
> > adding missing max_current and setting it to max safe value 100 (10 mA).
...
 
> Reviewed and found logically and technically correct
> Signed-off-by: Joerg Reisenweber <joerg AT openmoko DOT org>

Thanks, I'll apply this into omap-for-v3.12/fixes as it's a
regression.

Regards,

Tony
