Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751555Ab3FXNI3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 09:08:29 -0400
Received: from mail-1.atlantis.sk ([80.94.52.57]:55904 "EHLO
	mail-1.atlantis.sk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751285Ab3FXNIZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 09:08:25 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: Zdenek Kaspar <zkaspar82@gmail.com>
Subject: Re: SATA hdd refuses to reallocate a sector?
Date: Mon, 24 Jun 2013 15:08:07 +0200
User-Agent: KMail/1.9.10 (enterprise35 0.20100827.1168748)
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
References: <20130623101940.GA4448@amd.pavel.ucw.cz> <51C84038.6090507@gmail.com>
In-Reply-To: <51C84038.6090507@gmail.com>
X-KMail-QuotePrefix: > 
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201306241508.07377.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 24 June 2013, Zdenek Kaspar wrote:
> On 06/23/2013 12:19 PM, Pavel Machek wrote:
> > Hi!
> >
> > This may very well be hw problem, but...
> >
> > I have error on sda4. I tried to make hdd reallocate it by writing
> > zeros there, but it will not. Is there special kind of write that
> > needs to be done to force reallocation?
>
> Hi Pavel, maybe smartctl -t long /dev/sda will do the trick reliable for
> your drive..

It's a read-only test that ends with an error on the first bad sector.

-- 
Ondrej Zary
