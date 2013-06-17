Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754168Ab3FQRzP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 13:55:15 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39851 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753992Ab3FQRzL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 13:55:11 -0400
Date: Mon, 17 Jun 2013 10:55:10 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH/RESEND 01/12] msm_serial: Convert to clk_prepare/unprepare
Message-ID: <20130617175510.GA15370@kroah.com>
References: <1371490999-15501-1-git-send-email-sboyd@codeaurora.org>
 <1371490999-15501-2-git-send-email-sboyd@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1371490999-15501-2-git-send-email-sboyd@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 17, 2013 at 10:43:08AM -0700, Stephen Boyd wrote:
> Add calls to clk_prepare and unprepare so that MSM can migrate to
> the common clock framework.
> 
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Or do you want me to take the serial ones through my tree?  It's your
choice, either is fine for me.

thanks,

greg k-h
