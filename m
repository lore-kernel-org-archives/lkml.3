Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935658Ab3FTC6V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 22:58:21 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:38562 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935557Ab3FTC6U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 22:58:20 -0400
Date: Wed, 19 Jun 2013 19:59:00 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Christoph Anton Mitterer <calestyo@scientia.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: support for Intel Atom based QNAP LEDs/buttons/buzzer in Linux?
Message-ID: <20130620025900.GA21820@kroah.com>
References: <1371259861.12984.6.camel@heisenberg.scientia.net>
 <1371687272.30351.13.camel@heisenberg.scientia.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1371687272.30351.13.camel@heisenberg.scientia.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 20, 2013 at 02:14:32AM +0200, Christoph Anton Mitterer wrote:
> Well perhaps someone else with enough knowledge has time to look into
> this,... or perhaps someone has some good contacts over at QNAP and is
> able to lobby them to submit their code to the mainline kernel; I tried
> to contact their support but got no answer.

If you can dig the code out into a stand-alone form that I can make into
a patch for the drivers/staging/ tree, I'll be glad to take it.  Or, if
you get a contact at QNAP, I'll be glad to help out there as well, as
that's what we do all the time for loads of companies.

Good luck,

greg k-h
