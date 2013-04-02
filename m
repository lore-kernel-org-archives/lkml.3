Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761606Ab3DBQR0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 12:17:26 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:24355 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761097Ab3DBQRZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 12:17:25 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/f9ou493/x4PA9GQz60XWA
Date: Tue, 2 Apr 2013 09:17:14 -0700
From: Tony Lindgren <tony@atomide.com>
To: =?utf-8?B?0JjQstCw0LnQu9C+INCU0LjQvNC40YLRgNC+0LI=?= 
	<freemangordon@abv.bg>
Cc: pali.rohar@gmail.com, juha.yrjola@solidboot.com, linux@arm.linux.org.uk,
        mpm@selenic.com, herbert@gondor.hengli.com.au,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] OMAP3 ROM Random Number Generator support
Message-ID: <20130402161713.GR10155@atomide.com>
References: <414980284.76676.1364848631348.JavaMail.apache@mail82.abv.bg>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <414980284.76676.1364848631348.JavaMail.apache@mail82.abv.bg>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Ивайло Димитров <freemangordon@abv.bg> [130401 13:41]:
>  It could be that I am misreading something, but RX51 is OMAP3.

Yes the FIQs are only accessible in the secure mode starting with
omap2. So that also means omap3, 4, 5.

Regards,

Tony
