Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755146AbaFRUBG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 16:01:06 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:34724 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754569AbaFRUBE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 16:01:04 -0400
Date: Wed, 18 Jun 2014 21:00:54 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
Cc: Rob Herring <robherring2@gmail.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Will Deacon <will.deacon@arm.com>,
        Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        Sebastian Reichel <sre@debian.org>, Pavel Machek <pavel@ucw.cz>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] ARM: /proc/cpuinfo: Use DT machine name when possible
Message-ID: <20140618200053.GK32514@n2100.arm.linux.org.uk>
References: <1403110464-29646-1-git-send-email-pali.rohar@gmail.com> <CAL_JsqKw-C6uZBU3hccGmdofXcCcUKTV6z7Af6KwYwnZiy3HoQ@mail.gmail.com> <201406182122.29623@pali>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201406182122.29623@pali>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 18, 2014 at 09:22:29PM +0200, Pali Rohár wrote:
> So without this patch DT migration for Nokia N900 cannot be done 
> without breaking userspace - which is not acceptable...
> 
> Also I still did not know why DT kernel does not report Revision 
> number which is passed by bootloader via atags. Any idea?

It was a concious decision by the DT people to exclude most of the ATAGs
which provide that information.  Only memory information and command line
ATAGs are merged into DT.  Every other tag is ignored (as there's no
place for it in DT.)

-- 
FTTC broadband for 0.8mile line: now at 9.7Mbps down 460kbps up... slowly
improving, and getting towards what was expected from it.
