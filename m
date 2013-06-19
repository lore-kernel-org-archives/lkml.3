Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757021Ab3FSRWD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 13:22:03 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34904 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756717Ab3FSRWA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 13:22:00 -0400
Date: Wed, 19 Jun 2013 10:21:41 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Robin Holt <holt@sgi.com>, Russell King <rmk+kernel@arm.linux.org.uk>,
        Russ Anderson <rja@sgi.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Guan Xuetao <gxt@mprc.pku.edu.cn>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        Arm Mailing List <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH -v11 resend 10/11] arm, change reboot_mode to use enum
 reboot_mode
Message-Id: <20130619102141.411c8e39.akpm@linux-foundation.org>
In-Reply-To: <12642293.RmlRtOVM54@wuerfel>
References: <1370519244-49918-1-git-send-email-holt@sgi.com>
	<1370519244-49918-11-git-send-email-holt@sgi.com>
	<4169120.1k31YLDD12@wuerfel>
	<12642293.RmlRtOVM54@wuerfel>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Jun 2013 15:52:02 +0200 Arnd Bergmann <arnd@arndb.de> wrote:

> On Wednesday 19 June 2013 12:58:10 Arnd Bergmann wrote:
> > On Thursday 06 June 2013 06:47:23 Robin Holt wrote:
> > > Preparing to move the parsing of reboot= to generic kernel code
> > > forces the change in reboot_mode handling to use the enum.
> > > 
> > > Signed-off-by: Robin Holt <holt@sgi.com>
> > > To: Andrew Morton <akpm@linux-foundation.org>
> > > Cc: Russell King <rmk+kernel@arm.linux.org.uk>
> > > Cc: Russ Anderson <rja@sgi.com>
> > > Cc: Robin Holt <holt@sgi.com>
> > > Cc: H. Peter Anvin <hpa@zytor.com>
> > > Cc: Guan Xuetao <gxt@mprc.pku.edu.cn>
> > > Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
> > > Cc: the arch/x86 maintainers <x86@kernel.org>
> > > Cc: Arm Mailing List <linux-arm-kernel@lists.infradead.org>
> > > Acked-by: Russell King <rmk+kernel@arm.linux.org.uk>
> > 
> > Should we merge this through the arm-soc tree?
> > 
> > I'm getting a few conflicts with new platforms getting added
> > using the old interface.
> 
> Hmm, I realized after sending it that this patch depends on
> at least one other patch to add the 'enum'. Any suggestions
> for how to handle that?

This patchset gets a lot of rejects which I keep on fixing up.  Please
merge up early in the merge window and compile-test (and review) the
linux-next changes to make sure I didn't muck up the reject-fixing,
then we should be fine.
