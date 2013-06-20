Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161255Ab3FTV2g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 17:28:36 -0400
Received: from mailgw01.dd24.net ([193.46.215.41]:42347 "EHLO
	mailgw01.dd24.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161215Ab3FTV2f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 17:28:35 -0400
Subject: Re: support for Intel Atom based QNAP LEDs/buttons/buzzer in Linux?
From: Christoph Anton Mitterer <calestyo@scientia.net>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, wokeswang@qnap.com
In-Reply-To: <20130620025900.GA21820@kroah.com>
References: <1371259861.12984.6.camel@heisenberg.scientia.net>
	 <1371687272.30351.13.camel@heisenberg.scientia.net>
	 <20130620025900.GA21820@kroah.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 20 Jun 2013 23:28:26 +0200
Message-ID: <1371763706.5197.6.camel@fermat.scientia.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Greg.

On Wed, 2013-06-19 at 19:59 -0700, Greg KH wrote:
> If you can dig the code out into a stand-alone form that I can make into
> a patch for the drivers/staging/ tree, I'll be glad to take it.
Well I don't think my kernel/hardware development skills are enough for
that... especially as Guenter already said that the code shouldn't be
part of hwmon/it87 ... but rather a separate gpio driver...


> Or, if
> you get a contact at QNAP, I'll be glad to help out there as well
Well I've asked them again,... no reply so far.
The only direct contact I know (from the sources of their drivers) is
Wokes Wang, which I've CCed. Perhaps he can help.


>  as
> that's what we do all the time for loads of companies.
sure...


Cheers,
Chris.

