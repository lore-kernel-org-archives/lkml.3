Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752870Ab3LPJAl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 04:00:41 -0500
Received: from mail.abilis.ch ([195.70.19.74]:11487 "EHLO mail.abilis.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751793Ab3LPJAk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 04:00:40 -0500
Date: Mon, 16 Dec 2013 09:59:39 +0100
From: Christian Ruppert <christian.ruppert@abilis.com>
To: Borislav Petkov <bp@alien8.de>, Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Pavel Roskin <proski@gnu.org>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Sam Ravnborg <sam@ravnborg.org>,
        Noam Camus <noamc@ezchip.com>, Joe Perches <joe@perches.com>
Subject: Re: [PATCH 2/2 v2] x86: Add support for uncompressed kernel images
Message-ID: <20131216085938.GA15050@ab42.lan>
References: <20131118112504.GA27541@pd.tnic>
 <1384782510-5097-1-git-send-email-christian.ruppert@abilis.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1384782510-5097-1-git-send-email-christian.ruppert@abilis.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 18, 2013 at 02:48:30PM +0100, Christian Ruppert wrote:
> There seems to be some interest to enable uncompressed kernels also for x86
> in addition to (embedded) ARC platforms.
> 
> Add the code to support uncompressed kernels to lib/, select the respective
> Kconfig options for the x86 architecture and use this code in the x86 kernel
> self-decompressor.

Any news on this? Was someone able to take a look at / test this patch?
I have given it some more testing and encountered no issues so far.

Greetings,
  Christian
