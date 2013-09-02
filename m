Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757469Ab3IBGXQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 02:23:16 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:34421 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753498Ab3IBGXO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 02:23:14 -0400
Date: Mon, 2 Sep 2013 07:23:10 +0100
From: Matt Fleming <matt@console-pimps.org>
To: David Woodhouse <dwmw2@infradead.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org
Subject: Re: UEFI Plugfest 2013 -- New Orleans
Message-ID: <20130902062310.GA28598@console-pimps.org>
References: <20130816152030.GL2133@tuxdriver.com>
 <1376900735.2322.26.camel@shinybook.infradead.org>
 <20130819125507.GA19093@srcf.ucam.org>
 <1376925765.2069.24.camel@dabdike.int.hansenpartnership.com>
 <20130819160018.GA22532@srcf.ucam.org>
 <1376931775.2069.46.camel@dabdike.int.hansenpartnership.com>
 <20130819172139.GA24393@srcf.ucam.org>
 <1376933926.2069.52.camel@dabdike.int.hansenpartnership.com>
 <1376942994.2322.39.camel@shinybook.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1376942994.2322.39.camel@shinybook.infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Aug, at 09:09:54PM, David Woodhouse wrote:
> 3. Even if we can't *remove* the code, sometimes we can disable it at
> runtime if we detect the BIOS is new enough that it shouldn't be broken.
 
Yes, this is definitely something we should be looking to implement.

It seems likely to me that we're eventually going to start hitting
issues supporting the latest UEFI firmware because of the workarounds
we're currently carrying in the kernel. The EDKII folks are surprised
time and time again to hear of the hoops we jump through in the kernel
to support buggy implementations.

It's only going to be a matter of time until we *have* to disable some
our workarounds in order to boot the most recent incarantions of UEFI.
Not least because carrying these workarounds unconditionally and
indefinitely severely limits our ability to innovate.

-- 
Matt Fleming, Intel Open Source Technology Center
