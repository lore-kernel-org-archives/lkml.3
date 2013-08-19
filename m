Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751703Ab3HSXOz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 19:14:55 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:50386 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751390Ab3HSXOx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 19:14:53 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Wolfram Sang <wsa@the-dreams.de>, linux-i2c@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] i2c: move of helpers into the core
Date: Tue, 20 Aug 2013 01:25:27 +0200
Message-ID: <3721030.UJAkTdQrEC@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.11.0-rc5+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <5212A293.2030903@wwwdotorg.org>
References: <1376918361-7014-1-git-send-email-wsa@the-dreams.de> <3792014.HtzPVmLjnf@vostro.rjw.lan> <5212A293.2030903@wwwdotorg.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, August 19, 2013 04:56:19 PM Stephen Warren wrote:
> On 08/19/2013 05:04 PM, Rafael J. Wysocki wrote:
> > On Monday, August 19, 2013 03:19:18 PM Wolfram Sang wrote:
> >> I2C of helpers used to live in of_i2c.c but experience (from SPI) shows
> >> that it is much cleaner to have this in the core. This also removes a
> >> circular dependency between the helpers and the core, and so we can
> >> finally register child nodes in the core instead of doing this manually
> >> in each driver. So, fix the drivers and documentation, too.
> > 
> > Perhaps we should do the analogous for ACPI then?
> > 
> > Rafael
> 
> Aargh. Why quote the entire patch just to say one line?

Because I didn't think I could just skip the patch? ;-)

Also I could trim the CC list quite a bit (done now).

