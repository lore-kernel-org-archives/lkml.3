Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751322AbaKJDZS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2014 22:25:18 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:60333 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751059AbaKJDZQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2014 22:25:16 -0500
Date: Mon, 10 Nov 2014 11:30:32 +0900
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Vineet Gupta <Vineet.Gupta1@synopsys.com>
Cc: "stable@vger.kernel.org" <stable@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        "arc-linux-dev@synopsys.com" <arc-linux-dev@synopsys.com>,
        Igor Guryanov <Igor.Guryanov@synopsys.com>
Subject: Re: ARC backport for stable 3.14
Message-ID: <20141110023032.GA13024@kroah.com>
References: <C2D7FE5348E1B147BCA15975FBA230753C5E6418@IN01WEMBXA.internal.synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <C2D7FE5348E1B147BCA15975FBA230753C5E6418@IN01WEMBXA.internal.synopsys.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 15, 2014 at 09:26:55AM +0000, Vineet Gupta wrote:
> Hi,
> 
> Can you please apply the following mainline commits to 3.14 stable (in the order below)
> 
> c3441edd2dea ARC: [SMP] General Fixes

That commit doesn't have a signed-off-by:, what happened?

> d75386363ee6 ARC: fix mmuv2 warning
> ef680cdc2437 ARC: Disable caches in early boot if so configured
> 
> Build/run tested on 3.14

All applied now, thanks.

greg k-h
