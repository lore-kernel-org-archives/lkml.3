Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754713Ab3CRUSu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 16:18:50 -0400
Received: from mail-pb0-f45.google.com ([209.85.160.45]:48428 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753202Ab3CRUSt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 16:18:49 -0400
Date: Mon, 18 Mar 2013 13:20:04 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Michael Leun <lkml20130126@newton.leun.net>
Cc: linux-kernel@vger.kernel.org,
        Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Imre Deak <imre.deak@intel.com>
Subject: Re: 3.8.2->3.8.3 i915 regression: GMBUS [i915 gmbus dpb] timed out,
 falling back to bit banging on pin 5
Message-ID: <20130318202004.GC11643@kroah.com>
References: <201303142136.24917.a.miskiewicz@gmail.com>
 <20130314231957.677dda68@xenia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130314231957.677dda68@xenia>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 14, 2013 at 11:19:57PM +0100, Michael Leun wrote:
> Hello,
> 
> On Thu, 14 Mar 2013 21:36:24 +0100
> Arkadiusz Miskiewicz <a.miskiewicz@gmail.com> wrote:
> 
> > After upgrading from 3.8.2 to 3.8.3 I'm getting regression :
> [...]
> > 2a9810441fcc26cf3f006f015f8a62094fe57a90 is the first bad commit
> 
> I also have an 3.8.2->3.8.3 regression which goes away with reverting
> the same patch - X comes up with 1024x768 instead of 1366x768.
> 
> Acer Aspire 1825PTZ
> 
> 00:02.0 VGA compatible controller: Intel Corporation Mobile 4 Series Chipset Integrated Graphics Controller (rev 07) (prog-if 00 [VGA controller])
>         Subsystem: Acer Incorporated [ALI] Device 0300
> 

Thanks for the report, I've reverted this patch, and another i915 patch
for the next 3.8-stable release, so all should be resolved then.

greg k-h
