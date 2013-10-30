Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753958Ab3J3LdC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 07:33:02 -0400
Received: from mail-la0-f41.google.com ([209.85.215.41]:35664 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752285Ab3J3LdA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 07:33:00 -0400
Date: Wed, 30 Oct 2013 12:32:53 +0100
From: Johan Hovold <jhovold@gmail.com>
To: Andrew Lunn <andrew@lunn.ch>
Cc: Johan Hovold <jhovold@gmail.com>, peter@hurleysoftware.com,
        gregkh@linuxfoundation.org, jslaby@suse.cz,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tty: Add C_MSPAR(tty)
Message-ID: <20131030113253.GC29813@localhost>
References: <1382527101-30473-1-git-send-email-andrew@lunn.ch>
 <20131029181746.GE29615@localhost>
 <20131029221521.GP27015@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131029221521.GP27015@lunn.ch>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 29, 2013 at 11:15:21PM +0100, Andrew Lunn wrote:
> On Tue, Oct 29, 2013 at 07:17:46PM +0100, Johan Hovold wrote:
> > On Wed, Oct 23, 2013 at 01:18:21PM +0200, Andrew Lunn wrote:
> > > Add the missing C_MSPAR(tty) macro.
> > 
> > Please rename the macro C_CMSPAR to be consistent with the other
> > termios-flag macros (with C_BAUD being the exception that confirms the
> > rule).
> 
> Hi Johan
> 
> O.K, i will rename it.
> 
> Should i add this to the MOXA patch series, or submit is separately?
> I'm just thinking about dependencies. It will probably be easier to
> take both through one tree.

Yeah, you're right. I was gonna mention this in my review of v4 (it's
under way). Submit them as a two-part series for v5 and Greg can take
them both through the usb tree.

Thanks,
Johan
