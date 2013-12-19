Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753993Ab3LSOCo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 09:02:44 -0500
Received: from mail.skyhub.de ([78.46.96.112]:45817 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753922Ab3LSOCb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 09:02:31 -0500
Date: Thu, 19 Dec 2013 15:02:21 +0100
From: Borislav Petkov <bp@alien8.de>
To: Jonas Bonn <jonas@southpole.se>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org
Subject: Re: Lockdep warning
Message-ID: <20131219140221.GA27143@pd.tnic>
References: <52B2F668.2030400@southpole.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <52B2F668.2030400@southpole.se>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 19, 2013 at 02:36:40PM +0100, Jonas Bonn wrote:
> Hi,
> 
> Here's a lockdep warning that I'm seeing on an MX28 with 3.13-rc4.
> This seems to happen as soon as the network link comes up...
> including the 'netdev' list here as the backtrace shows the FEC
> driver in the stacktrace.
> 
> Any advice on how to proceed to track this down appreciated...

In such situations I'd always search the net first, to see whether this
has been fixed already. Hint: try searching for "lockdep __udp4_lib_rcv"

:-)

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
