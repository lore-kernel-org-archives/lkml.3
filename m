Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754170Ab3H0XVe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 19:21:34 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43030 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753671Ab3H0XVd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 19:21:33 -0400
Date: Tue, 27 Aug 2013 16:23:51 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        David Brown <davidb@codeaurora.org>, devicetree@vger.kernel.org,
        linux-serial@vger.kernel.org, Kumar Gala <galak@codeaurora.org>
Subject: Re: [PATCH v2 0/5] Document msm_serial bindings and support newer
 uartdms
Message-ID: <20130827232351.GA27119@kroah.com>
References: <1377067686-31957-1-git-send-email-sboyd@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1377067686-31957-1-git-send-email-sboyd@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 20, 2013 at 11:48:01PM -0700, Stephen Boyd wrote:
> This patchset aligns the msm_serial driver more with downstream usage and
> also documents the msm_serial driver's DT binding. Along the way we
> update the clock names and add support for newer UARTDM hardware that
> isn't part of a GSBI and make the console layer use the extra registers in
> UARTDM.
> 
> Changes since v1:
>  * Dropped _clk postfix from {core,iface}_clk
>  * Split DT binding into two files
>  * Renamed DT binding files to match compatible strings
>  * Fixed up DT review comments
>  * Added new patch 5/5 (more than 1 char for UARTDM)

I took patches 1, 3, and 5 from this series, as it seems that the dt
bindings are still being discussed.

thanks,

greg k-h
