Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756607Ab3C1P6L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 11:58:11 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:50237 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752715Ab3C1P6K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 11:58:10 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19xSy5zGU9dRKrXOK+ekNG4
Date: Thu, 28 Mar 2013 08:58:04 -0700
From: Tony Lindgren <tony@atomide.com>
To: =?utf-8?B?0JjQstCw0LnQu9C+INCU0LjQvNC40YLRgNC+0LI=?= 
	<freemangordon@abv.bg>
Cc: pali.rohar@gmail.com, nm@ti.com, linux@arm.linux.org.uk,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] arm: omap: RX-51: ARM errata 430973 workaround
Message-ID: <20130328155803.GT10155@atomide.com>
References: <24838523.73311.1364448607026.JavaMail.apache@mail82.abv.bg>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <24838523.73311.1364448607026.JavaMail.apache@mail82.abv.bg>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Ивайло Димитров <freemangordon@abv.bg> [130327 22:34]:
>  Tony,
> 
> Who do you expect to make that code merge? Do you expect us to mechanically merge RX51 PPA API patch with the existing generic OMAP PPA API code putting #ifdefs all over the place? Not that it is impossible, but the only real piece of HW I have here is n900, so I just can't be sure the code will still work on the other platforms besides RX51, once the code modified. Please, advice on how to proceed.

Probably ifdefs won't work nice for other omapss. It seems that
your original patch is pretty close based on all that's been
discussed. Can you please repost with a proper patch description
also summarizing why we cannot have generci SMC API as discussed?

Thanks,

Tony
