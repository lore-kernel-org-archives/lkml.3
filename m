Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757189Ab3C3Sj0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Mar 2013 14:39:26 -0400
Received: from mail-da0-f49.google.com ([209.85.210.49]:62112 "EHLO
	mail-da0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757021Ab3C3SjZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Mar 2013 14:39:25 -0400
Date: Sat, 30 Mar 2013 11:35:26 -0700
From: Anton Vorontsov <anton@enomsg.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: Pali =?utf-8?B?Um9ow6Fy?= <pali.rohar@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
        Joerg Reisenweber <joerg@openmoko.org>,
        Ivaylo Dimitrov <freemangordon@abv.bg>
Subject: Re: [PATCH v2] New Nokia RX-51 power supply battery driver
Message-ID: <20130330183526.GA21198@lizard>
References: <19040462.WFXWijAIDd@pali>
 <20121030223922.GA29061@lizard>
 <2562836.SjVVyiPAk1@pali>
 <20130330180705.GE28947@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130330180705.GE28947@amd.pavel.ucw.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 30, 2013 at 07:07:05PM +0100, Pavel Machek wrote:
> On Wed 2012-10-31 10:48:40, Pali Rohár wrote:
> > Hello, I fixed style issues and added it to Makefile and Kconfig.
> > 
> > power_supply: Add Nokia RX-51 battery driver
> > 
> > This driver exporting battery design capacity, temperature and voltage
> > for battery in Nokia RX-51. This driver is needed for open source
> > battery management on Nokia RX-51 (N900).
> > 
> > Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
> 
> Reviewed-by: Pavel Machek <pavel@ucw.cz>

Thanks for the review, Pavel! Although, the patch is in Linus' tree long
ago. ;-)

Anton
