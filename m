Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758140Ab3CTL6h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 07:58:37 -0400
Received: from mail.skyhub.de ([78.46.96.112]:45919 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756056Ab3CTL6f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 07:58:35 -0400
Date: Wed, 20 Mar 2013 12:58:31 +0100
From: Borislav Petkov <bp@alien8.de>
To: ML netdev <netdev@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: 3.9-rc3 forcedeth lockdep splat with netconsole
Message-ID: <20130320115831.GC15471@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	ML netdev <netdev@vger.kernel.org>,
	lkml <linux-kernel@vger.kernel.org>
References: <20130320110150.GB15471@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130320110150.GB15471@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 20, 2013 at 12:01:51PM +0100, Borislav Petkov wrote:
> Hi,
> 
> when trying to log stuff with netconsole, I get the following:
> 
> [ … ]
> 
> [    2.036977] netpoll: netconsole: device eth0 not up yet, forcing it
> [    2.037632] forcedeth 0000:00:08.0: irq 42 for MSI/MSI-X
> [    2.037763] forcedeth 0000:00:08.0 eth0: MSI enabled
> [    2.038074] forcedeth 0000:00:08.0 eth0: no link during initialization
> [    2.780061] forcedeth 0000:00:08.0 eth0: link up

Hehe,

so it is actually funny to see the things lockdep is warning about,
in action: I was just able to hang the box with the last line above
appearing on the screen.

Fun.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
