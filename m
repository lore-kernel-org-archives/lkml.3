Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752170AbaKDW0X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 17:26:23 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:51583 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751303AbaKDW0W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 17:26:22 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Timur Tabi <timur@codeaurora.org>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Ning Li <ning.li@intel.com>, Alan Cox <alan@linux.intel.com>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 0/2] pinctrl: Intel Cherryview/Braswell support
Date: Tue, 04 Nov 2014 23:47:06 +0100
Message-ID: <4886671.cQ44SiRoEW@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <54594A4B.1030207@codeaurora.org>
References: <1415012493-134561-1-git-send-email-mika.westerberg@linux.intel.com> <4832015.R1NooRni06@vostro.rjw.lan> <54594A4B.1030207@codeaurora.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, November 04, 2014 03:51:07 PM Timur Tabi wrote:
> On 11/04/2014 07:31 AM, Rafael J. Wysocki wrote:
> > Actually, it's better to pull the device-properties branch:
> >
> > git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm.git device-properties
> >
> > because that contains the lastest changes.  It will be rebased in the future,
> > though, so don't merge it into your "immutable" branches.
> 
> I wish there were more examples on converting OF calls to device_prop* 
> calls.  I can't figure out how to obtain the size of a property without 
> reading the property data.  I think device_property_present() should be 
> modified to take an optional size property, just like of_find_property().

What exactly do you need the size of the property alone for?

Rafael

