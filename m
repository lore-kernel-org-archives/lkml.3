Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754083Ab3JWNPa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 09:15:30 -0400
Received: from mail1.bemta5.messagelabs.com ([195.245.231.152]:16620 "EHLO
	mail1.bemta5.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753760Ab3JWNP1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 09:15:27 -0400
X-Env-Sender: Johannes.Thumshirn@men.de
X-Msg-Ref: server-8.tower-179.messagelabs.com!1382534124!24310218!1
X-Originating-IP: [80.255.6.145]
X-StarScan-Received: 
X-StarScan-Version: 6.9.12; banners=-,-,-
X-VirusChecked: Checked
X-PGP-Universal: processed;
	by keys.men.de on Wed, 23 Oct 2013 15:15:25 +0200
Date: Wed, 23 Oct 2013 15:15:19 +0200
From: Johannes Thumshirn <johannes.thumshirn@men.de>
To: Lee Jones <lee.jones@linaro.org>
CC: Johannes Thumshirn <johannes.thumshirn@men.de>,
        Samuel Ortiz <sameo@linux.intel.com>, <linux-kernel@vger.kernel.org>,
        Andreas Werner <andreas.werner@men.de>
Subject: Re: [PATCH] mfd: lpc_sch: Ignore resource conflicts when adding mfd
 cells
Message-ID: <20131023131518.GA12340@jtlinux>
References: <1382527860-8959-1-git-send-email-johannes.thumshirn@men.de>
 <20131023130527.GE2620@lee--X1>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20131023130527.GE2620@lee--X1>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: [192.1.1.31]
X-OriginalArrivalTime: 23 Oct 2013 13:15:22.0434 (UTC) FILETIME=[EDD1CA20:01CECFF1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 23, 2013 at 02:05:27PM +0100, Lee Jones wrote:
> On Wed, 23 Oct 2013, Johannes Thumshirn wrote:
>
> > Currently probe of lpc_sch fails on Intel Poulsbo because of ACPI resource
> > conflicts. A solution is to  set the ignore_resource_conflicts flag in the mfd cells.
> >
> > Tested-by: Andreas Werner <andreas.werner@men.de>
> > Signed-off-by: Johannes Thumshirn <johannes.thumshirn@men.de>
> > ---
> >  drivers/mfd/lpc_sch.c |    3 +++
> >  1 file changed, 3 insertions(+)
>
> I'm okay with this change. I'll apply it until someone else complains.
>
> --
> Lee Jones
> Linaro STMicroelectronics Landing Team Lead
> Linaro.org │ Open source software for ARM SoCs
> Follow Linaro: Facebook | Twitter | Blog

 Wow, that was fast.

      Johannes
