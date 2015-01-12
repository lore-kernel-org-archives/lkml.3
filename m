Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751868AbbALLek (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 06:34:40 -0500
Received: from cpsmtpb-ews06.kpnxchange.com ([213.75.39.9]:60186 "EHLO
	cpsmtpb-ews06.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751039AbbALLej (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 06:34:39 -0500
Message-ID: <1421062476.22660.46.camel@x220>
Subject: Re: [PATCH v9 07/12] coresight-etm: add CoreSight ETM/PTM driver
From: Paul Bolle <pebolle@tiscali.nl>
To: Mathieu Poirier <mathieu.poirier@linaro.org>
Cc: Valentin Rothberg <valentinrothberg@gmail.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Pratik Patel <pratikp@codeaurora.org>,
        Vikas Varshney <varshney@ti.com>, Al Grant <Al.Grant@arm.com>,
        Jonas Svennebring <jonas.svennebring@avagotech.com>,
        James King <james.king@linaro.org>, Kaixu Xia <kaixu.xia@linaro.org>,
        Marcin Jabrzyk <marcin.jabrzyk@gmail.com>,
        "r.sengupta@samsung.com" <r.sengupta@samsung.com>,
        trollkarlen Marklund <robbelibobban@gmail.com>,
        Patch Tracking <patches@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 12 Jan 2015 12:34:36 +0100
In-Reply-To: <1415647928.21229.23.camel@x220>
References: <1415038066-22423-1-git-send-email-mathieu.poirier@linaro.org>
	 <1415038066-22423-8-git-send-email-mathieu.poirier@linaro.org>
	 <1415615671.4862.30.camel@x220>
	 <CANLsYkxivqgyRZspS2uP9Mkwit4obCjZxYr0YUhR3G_zQejERg@mail.gmail.com>
	 <1415647928.21229.23.camel@x220>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 12 Jan 2015 11:34:36.0651 (UTC) FILETIME=[BE7D03B0:01D02E5B]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-11-10 at 20:32 +0100, Paul Bolle wrote:
> On Mon, 2014-11-10 at 08:40 -0700, Mathieu Poirier wrote:
> > On 10 November 2014 03:34, Paul Bolle <pebolle@tiscali.nl> wrote:
> > > On Mon, 2014-11-03 at 11:07 -0700, mathieu.poirier@linaro.org wrote:
> > >> +#ifdef CONFIG_CORESIGHT_SOURCE_ETM_DEFAULT_ENABLE
> > >
> > > There's no Kconfig symbol CORESIGHT_SOURCE_ETM_DEFAULT_ENABLE. Neither
> > > is there a preprocessor definition of this macro. So why was this
> > > added?
> > 
> > Correct - the feature (as we really want it) is currently being worked
> > on but not yet part of the code base.  The default option probably
> > should have been removed but it doesn't do much else when mandating
> > one to add a boot option on the kernel cmd line.
> 
> I'm afraid I'm not sure what you mean here. Anyhow, using a Kconfig
> symbol to set a default for something that can also be set through a
> kernel parameter might be considered overdoing it. But that's not for me
> to decide.
> 
> Unless the patch that adds this Kconfig symbol takes a long time to land
> in linux-next, I won't be bothering you again.

Two months have passed. This code made it unchanged into v3.19-rc1. A
Kconfig symbol CORESIGHT_SOURCE_ETM_DEFAULT_ENABLE is not yet part of
linux-next.

Should I submit a trivial patch to drop the useless check for
CONFIG_CORESIGHT_SOURCE_ETM_DEFAULT_ENABLE?


Paul Bolle

