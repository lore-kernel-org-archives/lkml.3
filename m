Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752695AbaHAAUu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 20:20:50 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:38170 "EHLO
	out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751344AbaHAAUt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 20:20:49 -0400
X-Sasl-enc: sNKyG2C2xVyrSLVCF33EQ8SwJTUTtzLcKC99XaXio3Fr 1406852446
Date: Thu, 31 Jul 2014 17:20:17 -0700
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        David Riley <davidriley@chromium.org>,
        John Stultz <john.stultz@linaro.org>
Subject: Re: linux-next: manual merge of the driver-core tree with the tip
 tree
Message-ID: <20140801002017.GA2945@kroah.com>
References: <20140731170735.5cf2062b@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140731170735.5cf2062b@canb.auug.org.au>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 31, 2014 at 05:07:35PM +1000, Stephen Rothwell wrote:
> Hi Greg,
> 
> Today's linux-next merge of the driver-core tree got a conflict in
> lib/Kconfig.debug between commit e704f93af5a0 ("kernel: time: Add
> udelay_test module to validate udelay") from the tip tree and commit
> 0a8adf584759 ("test: add firmware_class loader test") from the
> driver-core tree.
> 
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).

Looks good, thanks.

greg k-h
