Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752147AbaBIPbN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 10:31:13 -0500
Received: from mail.skyhub.de ([78.46.96.112]:34034 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751830AbaBIPbK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 10:31:10 -0500
Date: Sun, 9 Feb 2014 16:31:07 +0100
From: Borislav Petkov <bp@alien8.de>
To: Daniel Exner <dex@dragonslave.de>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: Poor network performance x86_64.. also with 3.13
Message-ID: <20140209153107.GA8614@pd.tnic>
References: <52DAD66F.7080306@dragonslave.de>
 <20140118195026.GA15543@pd.tnic>
 <52DB0439.2060905@dragonslave.de>
 <52DDA2CD.9040001@dragonslave.de>
 <20140120223752.GA3057@pd.tnic>
 <20140209160511.2f67866f@Mycroft>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140209160511.2f67866f@Mycroft>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 09, 2014 at 04:05:11PM +0100, Daniel Exner wrote:
> > cat /etc/sysctl.d/net.conf
> > net.ipv4.tcp_window_scaling = 1
> > net.core.rmem_max = 16777216
> > net.ipv4.tcp_rmem = 4096 87380 16777
> > net.ipv4.tcp_wmem = 4096       1638
> 
> After removing those values I finally had sane iperf values.
> No idea how those got there, perhaps they made sense when I first setup
> the box, which is some years ago..

The only question that is left to clarify now is why do those values
have effect on 3.12.x and not on 3.10...

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
