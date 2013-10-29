Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751859Ab3J2WUG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 18:20:06 -0400
Received: from vps0.lunn.ch ([178.209.37.122]:45330 "EHLO vps0.lunn.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751125Ab3J2WUE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 18:20:04 -0400
Date: Tue, 29 Oct 2013 23:15:21 +0100
From: Andrew Lunn <andrew@lunn.ch>
To: Johan Hovold <jhovold@gmail.com>
Cc: Andrew Lunn <andrew@lunn.ch>, peter@hurleysoftware.com,
        gregkh@linuxfoundation.org, jslaby@suse.cz,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tty: Add C_MSPAR(tty)
Message-ID: <20131029221521.GP27015@lunn.ch>
References: <1382527101-30473-1-git-send-email-andrew@lunn.ch>
 <20131029181746.GE29615@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131029181746.GE29615@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 29, 2013 at 07:17:46PM +0100, Johan Hovold wrote:
> On Wed, Oct 23, 2013 at 01:18:21PM +0200, Andrew Lunn wrote:
> > Add the missing C_MSPAR(tty) macro.
> 
> Please rename the macro C_CMSPAR to be consistent with the other
> termios-flag macros (with C_BAUD being the exception that confirms the
> rule).

Hi Johan

O.K, i will rename it.

Should i add this to the MOXA patch series, or submit is separately?
I'm just thinking about dependencies. It will probably be easier to
take both through one tree.

Thanks
	Andrew
