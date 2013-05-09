Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754398Ab3EIL3o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 07:29:44 -0400
Received: from relay2.sgi.com ([192.48.179.30]:55921 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754131Ab3EIL3m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 07:29:42 -0400
Date: Thu, 9 May 2013 06:29:41 -0500
From: Robin Holt <holt@sgi.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Robin Holt <holt@sgi.com>, Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Guan Xuetao <gxt@mprc.pku.edu.cn>,
        Russ Anderson <rja@sgi.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        Arm Mailing List <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH -v8 11/11] Move arch/x86 reboot= handling to generic
 kernel.
Message-ID: <20130509112941.GV3672@sgi.com>
References: <1367937595-32241-1-git-send-email-holt@sgi.com>
 <1367937595-32241-12-git-send-email-holt@sgi.com>
 <20130508182304.GP18614@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130508182304.GP18614@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 08, 2013 at 07:23:05PM +0100, Russell King - ARM Linux wrote:
> On Tue, May 07, 2013 at 09:39:55AM -0500, Robin Holt wrote:
> > +		case 's':
> > +			reboot_mode = REBOOT_WARM;
> > +		case 'h':
> > +			reboot_mode = REBOOT_COLD;
> > +		case 'g':
> > +			reboot_mode = REBOOT_GPIO;
> 
> Further to Ingo's comments, also note that the above is broken.  Any
> of s,h,g will result in REBOOT_GPIO being set which is clearly wrong.

I couldn't be more of an idiot.  I will fix it in -v9.

Robin
