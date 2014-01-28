Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754810AbaA1JQR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 04:16:17 -0500
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.219]:14140 "EHLO
	mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751569AbaA1JQN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 04:16:13 -0500
X-RZG-AUTH: :P2EQZWCpfu+qG7CngxMFH1J+yackYocTD1iAi8x+OWi/zfN1cLnBYfstAo5SQMel8AXawDOUvwr8pxjMon91SD6m7JJcBA==
X-RZG-CLASS-ID: mo00
Date: Tue, 28 Jan 2014 10:16:07 +0100
From: Olaf Hering <olaf@aepfle.de>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [git pull] Please pull powerpc.git next branch
Message-ID: <20140128091607.GA24288@aepfle.de>
References: <1390883744.3872.76.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1390883744.3872.76.camel@pasglop>
User-Agent: Mutt/1.5.22.rev6346 (2013-10-29)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 28, Benjamin Herrenschmidt wrote:

> So here's my next branch for powerpc. A bit late as I was on vacation

This breaks booting on G5 11,2, the nouveau driver prints errors and as
result the kernel hangs, fans kick in. This is what I did:

# Rebase 54c0a4b..b2e448e onto 54c0a4b

I will try to bisect it.

Olaf
