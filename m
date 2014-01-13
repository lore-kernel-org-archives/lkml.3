Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752240AbaAMWSC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 17:18:02 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:61585 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751642AbaAMWSA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 17:18:00 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Scott Wood <scottwood@freescale.com>
Subject: Re: [PATCH] Driver/IFC: Move Freescale IFC driver to a common driver
Date: Mon, 13 Jan 2014 23:17:54 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Prabhakar Kushwaha <prabhakar@freescale.com>, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org
References: <1389590671-20289-1-git-send-email-prabhakar@freescale.com> <201401132222.12572.arnd@arndb.de> <1389648261.24905.82.camel@snotra.buserror.net>
In-Reply-To: <1389648261.24905.82.camel@snotra.buserror.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201401132317.55033.arnd@arndb.de>
X-Provags-ID: V02:K0:Fm4XhSuQ0xq6TaEBMvxRg5cVBbksy//ULLTs53R1GLk
 LZnWET7XDJV1yUN/6we5JfjWWiDuWQ4zeayU15157j8N9DNvwy
 5SaS3DQVgI7xUxAsRtlHaqnFpZHNnnWpPE4H61bJ021kMTc8Az
 mfFblEZb5DT2DCciBssQmkhDy+0xRN5eddCSjXBF2TF9iv7SeV
 jQKUGundvHo7Hoa1AH6NPHAg2+nz71rR9BHDKW+FPGqBdaiijk
 tPLP8SMB2vhHFQXQS+7N1vuCJcTTLG9031EZVn0SWUbAGOTbcB
 G5j+3KWffodPlzMWw3YUGR7d+bWfnjmd2wdsXOwo+g1yhk7ZWX
 Zeof4j4284VDHmrHT7gw=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 13 January 2014, Scott Wood wrote:
> On Mon, 2014-01-13 at 22:22 +0100, Arnd Bergmann wrote:
> > On Monday 13 January 2014, Scott Wood wrote:
> > > 
> > > Some of the things behind it are flash, but those portions of the driver
> > > are already in drivers/mtd.  This is just the common code.
> > > 
> > 
> > What are the things that are not flash then?
> 
> FPGAs or any other random things that might get connected to it on a
> custom board.

Ok, that is similar to a number of other external buses then, like the
mvebu-devbus.c. I'd suggest you put it in drivers/memory.

	Arnd
