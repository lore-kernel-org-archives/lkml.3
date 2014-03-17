Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932829AbaCQS2z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 14:28:55 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:60873 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932706AbaCQS2w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 14:28:52 -0400
X-Sasl-enc: KqfpfVAGUMVvPdHMx2hoa4FDEDfA4rbMpBT0hGxKctvz 1395080931
Date: Mon, 17 Mar 2014 11:30:52 -0700
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paul Bolle <pebolle@tiscali.nl>,
        Magnus Damm <damm@opensource.se>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Wolfram Sang <wsa@sang-engineering.com>
Subject: Re: linux-next: manual merge of the usb tree with the tip tree
Message-ID: <20140317183052.GD10565@kroah.com>
References: <20140317183126.7c8ba1901c81fbb9ace00f20@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140317183126.7c8ba1901c81fbb9ace00f20@canb.auug.org.au>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 17, 2014 at 06:31:26PM +1100, Stephen Rothwell wrote:
> Hi Greg,
> 
> Today's linux-next merge of the usb tree got a conflict in
> arch/arm/mach-shmobile/Kconfig between commit aeb8fb7910fc ("ARM:
> shmobile: Remove CMT, TMU and STI Kconfig entries") from the tip tree and
> commit f6723b569a67 ("usb: host: remove selects of USB_ARCH_HAS_?HCI")
> from the usb tree.
> 
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).

Looks good, thanks.

greg k-h
