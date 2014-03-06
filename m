Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751597AbaCFJAT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 04:00:19 -0500
Received: from mail-ig0-f179.google.com ([209.85.213.179]:45887 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750834AbaCFJAR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 04:00:17 -0500
Date: Thu, 6 Mar 2014 04:00:13 -0500
From: Matt Porter <mporter@linaro.org>
To: Alex Elder <elder@linaro.org>
Cc: bcm@fixthebug.org, linux-arm-kernel@lists.infradead.org,
        bcm-kernel-feedback-list@broadcom.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mach-bcm: bcm281xx: symbol cleanup
Message-ID: <20140306090013.GF25092@beef>
References: <1393369305-4748-1-git-send-email-elder@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1393369305-4748-1-git-send-email-elder@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 25, 2014 at 05:01:45PM -0600, Alex Elder wrote:
> This patch renames a few symbols that needlessly used "11351" rather
> than "281xx" in their names.
> 
> Support for the bcm11351 board is being removed from the kernel, and
> the family of boards is more properly referred to as "bcm281xx".
> 
> Signed-off-by: Alex Elder <elder@linaro.org>

Applied to mach-bcm for-3.15/cleanup

-Matt
