Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755785AbaAVQlO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 11:41:14 -0500
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:45426 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755471AbaAVQlH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 11:41:07 -0500
Date: Wed, 22 Jan 2014 16:41:00 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: John Tobias <john.tobias.ph@gmail.com>
Cc: "<linux-arm-kernel@lists.infradead.org>" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "<linux-kernel@vger.kernel.org>" <linux-kernel@vger.kernel.org>
Subject: Re: Internal error: Oops: 17 [#1] ARM
Message-ID: <20140122164100.GE15937@n2100.arm.linux.org.uk>
References: <CACUGKYPXficVuqDgy6_Tnh9b-VOXDNK=+nqb6U5O6NpcZOGGpQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACUGKYPXficVuqDgy6_Tnh9b-VOXDNK=+nqb6U5O6NpcZOGGpQ@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 22, 2014 at 08:23:36AM -0800, John Tobias wrote:
> Hello all,
> 
> I am using 3.13-rc1 kernel on iMX6SL processor. My filesystem is in
> eMMC running SDR50.
> Is anyone here encountered these problem and if there's any existing
> patch that I can get?.

How reproducable is this?  I notice you're using 3.13-rc1 too, it could
be the bug has already been fixed in a later kernel version.  -rc1
kernels are really the "fresh after lots of new feature merging" kernels
which should always be expected to be rather buggy.

Linux kernel "release candidates" are not "we think this is going to be
a final kernel, please test it" but -rc1 marks the end of the new
feature merging and the beginning of the stablisation phase.

-- 
FTTC broadband for 0.8mile line: 5.8Mbps down 500kbps up.  Estimation
in database were 13.1 to 19Mbit for a good line, about 7.5+ for a bad.
Estimate before purchase was "up to 13.2Mbit".
