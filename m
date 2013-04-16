Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757485Ab3DPNtz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 09:49:55 -0400
Received: from ra.se.axis.com ([195.60.68.13]:45598 "EHLO ra.se.axis.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756731Ab3DPNty (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 09:49:54 -0400
Date: Tue, 16 Apr 2013 15:46:49 +0200
From: Jesper Nilsson <jesper.nilsson@axis.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Jesper Nilsson <jespern@axis.com>, Mikael Starvik <starvik@axis.com>,
        Jesper Nilsson <jespern@axis.com>, Valdis.Kletnieks@vt.edu,
        linux-cris-kernel@axis.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] cris: drop unused Kconfig symbols
Message-ID: <20130416134649.GQ11974@axis.com>
References: <1318595467.6132.80.camel@x61.thuisdomein>
 <20111014133354.GE9412@axis.com>
 <14215.1318619461@turing-police.cc.vt.edu>
 <20111031105959.GA26898@axis.com>
 <1364044486.1390.237.camel@x61.thuisdomein>
 <20130415151132.GJ11974@axis.com>
 <1366101244.25115.11.camel@x61.thuisdomein>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1366101244.25115.11.camel@x61.thuisdomein>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 16, 2013 at 10:34:04AM +0200, Paul Bolle wrote:
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> ---
> 0) The first version had the subject "[PATCH 21/21] cris: drop unused
> Kconfig symbols".
> 
> 1) This version was redone on top of v3.9-rc7. The changes since the
> first version are:
> - dropped OOM_REBOOT (I sent a separate patch for that symbol because I
> didn't realize it was part of the first version, as it is the only
> symbol without the EXTRAX_ prefix);
> - added ETRAX_ETHERNET_IFACE0, ETRAX_ETHERNET_IFACE1, and
> ETRAX_SERIAL_PORT4 (my scripts got smarter).
> 
> 2) This patch can be tested (after applying) with this one-liner:
>     for symbol in $(git log -1 -p | grep "^-config" | awk '{ print $2 }'); do git grep -n "$symbol\b"; done
> 
> That should show no output.

Thanks, applied to the CRIS-tree.

/^JN - Jesper Nilsson
-- 
               Jesper Nilsson -- jesper.nilsson@axis.com
