Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753468Ab3CNW0G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 18:26:06 -0400
Received: from stator.leun.net ([85.214.203.199]:54107 "EHLO stator.leun.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753278Ab3CNW0E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 18:26:04 -0400
X-Greylist: delayed 337 seconds by postgrey-1.27 at vger.kernel.org; Thu, 14 Mar 2013 18:26:03 EDT
Date: Thu, 14 Mar 2013 23:19:57 +0100
From: Michael Leun <lkml20130126@newton.leun.net>
To: linux-kernel@vger.kernel.org
Cc: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Imre Deak <imre.deak@intel.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
Subject: Re: 3.8.2->3.8.3 i915 regression: GMBUS [i915 gmbus dpb] timed out,
 falling back to bit banging on pin 5
Message-ID: <20130314231957.677dda68@xenia>
In-Reply-To: <201303142136.24917.a.miskiewicz@gmail.com>
References: <201303142136.24917.a.miskiewicz@gmail.com>
Organization: Not Organized
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.14; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, 14 Mar 2013 21:36:24 +0100
Arkadiusz Miskiewicz <a.miskiewicz@gmail.com> wrote:

> After upgrading from 3.8.2 to 3.8.3 I'm getting regression :
[...]
> 2a9810441fcc26cf3f006f015f8a62094fe57a90 is the first bad commit

I also have an 3.8.2->3.8.3 regression which goes away with reverting
the same patch - X comes up with 1024x768 instead of 1366x768.

Acer Aspire 1825PTZ

00:02.0 VGA compatible controller: Intel Corporation Mobile 4 Series Chipset Integrated Graphics Controller (rev 07) (prog-if 00 [VGA controller])
        Subsystem: Acer Incorporated [ALI] Device 0300


-- 
MfG,

Michael Leun

