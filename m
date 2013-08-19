Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751115Ab3HSOzt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 10:55:49 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:51613 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751033Ab3HSOzr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 10:55:47 -0400
Date: Mon, 19 Aug 2013 07:57:34 -0700
From: greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Vineet Gupta <Vineet.Gupta1@synopsys.com>
Cc: "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "noamc@ezchip.com" <noamc@ezchip.com>,
        Anton Kolesov <Anton.Kolesov@synopsys.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] ARC: gdbserver breakage in Big-Endian configuration
 #1
Message-ID: <20130819145734.GA15353@kroah.com>
References: <1375969958-16454-1-git-send-email-vgupta@synopsys.com>
 <C2D7FE5348E1B147BCA15975FBA2307513FD98@IN01WEMBXA.internal.synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <C2D7FE5348E1B147BCA15975FBA2307513FD98@IN01WEMBXA.internal.synopsys.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 19, 2013 at 09:08:49AM +0000, Vineet Gupta wrote:
> Hi Greg,
> 
> I'd posted these patches for stable backport. Do I need to do anything more to get them included.
> 
> https://patchwork.kernel.org/patch/2841153/  [1/2] ARC: gdbserver breakage in Big-Endian configuration #1<https://patchwork.kernel.org/patch/2841153/>]
> https://patchwork.kernel.org/patch/2841158/  [2/2] ARC: gdbserver breakage in Big-Endian configuration #2<https://patchwork.kernel.org/patch/2841158/>

I ignored them as I thought you were submitting them for upstream
inclusion.  If they are already in Linus's tree, then take a look at the
file, Documentation/stable_kernel_rules.txt for how to send a patch for
inclusion into a stable release (hint, I need to know the git commit id
that the patch has in Linus's tree, which I didn't see anywhere here.)

thanks,

greg k-h
