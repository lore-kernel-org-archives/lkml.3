Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935366Ab3FSX0W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 19:26:22 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:43432 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934444Ab3FSX0V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 19:26:21 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Toshi Kani <toshi.kani@hp.com>
Cc: Tony Luck <tony.luck@gmail.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, "Lu, Aaron" <aaron.lu@intel.com>
Subject: Re: [PATCH 0/5] ACPI / scan: Make it possible to use the container hotplug with other scan handlers
Date: Thu, 20 Jun 2013 01:35:42 +0200
Message-ID: <11533663.1O1HHSYroG@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0-rc5+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1371684124.8433.2.camel@misato.fc.hp.com>
References: <1417592.vuSG0cUIGo@vostro.rjw.lan> <11631311.zzmyWFE0GU@vostro.rjw.lan> <1371684124.8433.2.camel@misato.fc.hp.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, June 19, 2013 05:22:04 PM Toshi Kani wrote:
> On Thu, 2013-06-20 at 00:24 +0200, Rafael J. Wysocki wrote:
> > On Wednesday, June 19, 2013 10:37:27 AM Tony Luck wrote:
> > > > Can you please apply the appended patch on top of it and see if the system
> > > > still works then?
> > > 
> > > Still works with this patch.
> > 
> > Cool, thanks! :-)
> > 
> > If you don't mind, I'll queue up https://patchwork.kernel.org/patch/2712741/ and
> > this for 3.11.
> 
> For both patches:
> 
> Acked-by: Toshi Kani <toshi.kani@hp.com>

Thanks!

