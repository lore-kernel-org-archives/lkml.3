Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757108Ab3C3SHJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Mar 2013 14:07:09 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:34547 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756915Ab3C3SHI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Mar 2013 14:07:08 -0400
Date: Sat, 30 Mar 2013 19:07:05 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
Cc: Anton Vorontsov <cbouatmailru@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
        Joerg Reisenweber <joerg@openmoko.org>,
        Ivaylo Dimitrov <freemangordon@abv.bg>
Subject: Re: [PATCH v2] New Nokia RX-51 power supply battery driver
Message-ID: <20130330180705.GE28947@amd.pavel.ucw.cz>
References: <19040462.WFXWijAIDd@pali>
 <20121030223922.GA29061@lizard>
 <2562836.SjVVyiPAk1@pali>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2562836.SjVVyiPAk1@pali>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2012-10-31 10:48:40, Pali Rohár wrote:
> Hello, I fixed style issues and added it to Makefile and Kconfig.
> 
> power_supply: Add Nokia RX-51 battery driver
> 
> This driver exporting battery design capacity, temperature and voltage
> for battery in Nokia RX-51. This driver is needed for open source
> battery management on Nokia RX-51 (N900).
> 
> Signed-off-by: Pali Rohár <pali.rohar@gmail.com>

Reviewed-by: Pavel Machek <pavel@ucw.cz>
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
