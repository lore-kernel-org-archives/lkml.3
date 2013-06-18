Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933364Ab3FRTwz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 15:52:55 -0400
Received: from mail2.gnudd.com ([213.203.150.91]:38001 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933029Ab3FRTwy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 15:52:54 -0400
Date: Tue, 18 Jun 2013 21:52:00 +0200
From: Alessandro Rubini <rubini@gnudd.com>
To: gregkh@linuxfoundation.org
Cc: juan.david.gonzalez.cobas@cern.ch, linux-kernel@vger.kernel.org,
        cota@braap.org, siglesias@igalia.com, rob@landley.net,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH 3/8] FMC: add core bus driver
Message-ID: <20130618195200.GA21331@mail.gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: GnuDD, Device Drivers, Embedded Systems, Courses
In-Reply-To: <20130618174047.GA21738@kroah.com>
References: <20130618174047.GA21738@kroah.com>
  <cover.1371018406.git.rubini@gnudd.com>
  <3e9f6b2fb7cd202da9bbb6371b27ff302ca8b860.1371018406.git.rubini@gnudd.com>
  <20130617231606.GB12984@kroah.com>
  <20130617233802.GA17517@mail.gnudd.com>
  <CADDK0KdrVgmXN-TZw8E43JRNk5Wb_cfM6pUWaSxbJ49GU72cTg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Alessandro, care to respin the patches that I didn't apply and resend
> them so that I can?

Yes, ASAP. But, according to the later message by David, I'll respin
with the BSD license for demo code and EXPORT_SYMBOL (no GPL-only
clause):

  https://lkml.org/lkml/2013/6/18/119

  "As mentioned, CERN policies are non-restrictive in this sense,
  hence we consider correct to leave EXPORT_SYMBOLs as they are
  currently. The BSD licencing for the other, "public domain" examples
  is also OK."

Shortly: since FMC is not a core component of the kernel, the market
is better served by allowing use of drivers/fmc also by those
companies whose lawyers are bigger than their developers. (disclaimer:
wording is mine). Even if CERN itself won't buy cards with proprietary
drivers.

/alessandro
