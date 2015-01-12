Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752653AbbALM0j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 07:26:39 -0500
Received: from cpsmtpb-ews05.kpnxchange.com ([213.75.39.8]:63165 "EHLO
	cpsmtpb-ews05.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752587AbbALM0f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 07:26:35 -0500
Message-ID: <1421065593.22660.57.camel@x220>
Subject: Re: MIPS: ralink: CONFIG_RALINK_ILL_ACC?
From: Paul Bolle <pebolle@tiscali.nl>
To: John Crispin <blogic@openwrt.org>
Cc: Valentin Rothberg <valentinrothberg@gmail.com>,
        Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org
Date: Mon, 12 Jan 2015 13:26:33 +0100
In-Reply-To: <1415622769.21229.15.camel@x220>
References: <1414403681.28499.4.camel@x220> <544E188B.9000707@openwrt.org>
	 <1415622769.21229.15.camel@x220>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 12 Jan 2015 12:26:33.0633 (UTC) FILETIME=[005AB910:01D02E63]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

John,

On Mon, 2014-11-10 at 13:32 +0100, Paul Bolle wrote:
> On Mon, 2014-10-27 at 11:03 +0100, John Crispin wrote:
> > On 27/10/2014 10:54, Paul Bolle wrote:
> > > Your commit 78865eacb4aa ("MIPS: ralink: add illegal access
> > > driver") landed in today's linux-next (ie, next-20141027). That
> > > commit dates back to May 16, 2013! It adds a driver that is built
> > > if CONFIG_RALINK_ILL_ACC is set. But there's no Kconfig symbol
> > > RALINK_ILL_ACC.
> > > 
> > > I assume that patch that adds this symbol is queued somewhere. Is
> > > that correct?
> > 
> > i'll look into it. the commit that move all dts files to a central
> > folder broke some of my patches so i had to rebase them. apparently
> > the bit that adds the symbol got lost.
> 
> (CONFIG_RALINK_ILL_ACC was already gone in next-20141029. So that issue
> is resolved, as far as I care.)

It returned in next-20141114 and then made it into mainline (v3.19-rc1
and later). But there's still no Kconfig symbol RALINK_ILL_ACC. What's
the status of the patch to add it?


Paul Bolle

