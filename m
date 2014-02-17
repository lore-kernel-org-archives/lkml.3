Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753095AbaBQJQY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 04:16:24 -0500
Received: from cpsmtpb-ews03.kpnxchange.com ([213.75.39.6]:53825 "EHLO
	cpsmtpb-ews03.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753073AbaBQJQU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 04:16:20 -0500
Message-ID: <1392628578.10966.28.camel@x220>
Subject: Re: [PATCH] s390: remove HAVE_MARCH_Z9?0_FEATURES
From: Paul Bolle <pebolle@tiscali.nl>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>, linux390@de.ibm.com,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 17 Feb 2014 10:16:18 +0100
In-Reply-To: <20140217091021.GB4651@osiris>
References: <1392570927.28866.12.camel@x220> <20140217082035.GA4651@osiris>
	 <1392627040.10966.18.camel@x220> <20140217091021.GB4651@osiris>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.3 (3.10.3-1.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 17 Feb 2014 09:16:18.0940 (UTC) FILETIME=[EAC30BC0:01CF2BC0]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-02-17 at 10:10 +0100, Heiko Carstens wrote:
> On Mon, Feb 17, 2014 at 09:50:40AM +0100, Paul Bolle wrote:
> > Completeness of what?
> 
> Each cpu generation we support is supposed to have a
> "HAVE_MARCH_<GENERATION>_FEATURES" config symbol.

But apparently these two generations can do fine without it.

> > Anyhow, perhaps you can comment this stuff out if you want to have it in
> > the tree. See, these symbols will pop up each time that people run their
> > scripts to discover problems in the kconfig space. I suppose this was
> > probably not the first time these two were reported. And people not
> > aware of this thread might do that again, and again...
> 
> What script did you use?

A local piece of perl.

It started rather cute but it has grown quite big now. I never let it
leaves its cage. I just push some food between the bars every now and
then.


Paul Bolle

