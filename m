Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754507Ab3C0XVF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 19:21:05 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:53953 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751804Ab3C0XVD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 19:21:03 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+QI35r8QVK+j71vaMqOria
Date: Wed, 27 Mar 2013 13:56:07 -0700
From: Tony Lindgren <tony@atomide.com>
To: Pali =?utf-8?B?Um9ow6Fy?= <pali.rohar@gmail.com>
Cc: Nishanth Menon <nm@ti.com>,
        =?utf-8?B?0JjQstCw0LnQu9C+INCU0LjQvNC40YLRgNC+0LI=?= 
	<freemangordon@abv.bg>,
        linux@arm.linux.org.uk, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] arm: omap: RX-51: ARM errata 430973 workaround
Message-ID: <20130327205606.GN10155@atomide.com>
References: <517283541.62064.1362124023621.JavaMail.apache@mail81.abv.bg>
 <20130306175120.GP11806@atomide.com>
 <201303062013.16302@pali>
 <201303241526.59275@pali>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201303241526.59275@pali>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Pali Rohár <pali.rohar@gmail.com> [130324 07:31]:
> it is possible to upstream errata 430973 workaround for RX-51?

I think we should make the SMC handling a generic function for ARM.

AFAIK just the SMC call numbering is different for various
implementations. So the handler and passing of the parameters
seems like it should be generic.

Regards,

Tony
