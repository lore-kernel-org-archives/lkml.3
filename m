Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752238AbbAVJec (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 04:34:32 -0500
Received: from mail-we0-f169.google.com ([74.125.82.169]:48992 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750849AbbAVJe1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 04:34:27 -0500
Date: Thu, 22 Jan 2015 09:34:23 +0000
From: Peter Griffin <peter.griffin@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, kernel@stlinux.com, wsa@the-dreams.de
Subject: Re: [STLinux Kernel] [PATCH 1/1] i2c: i2c-st: Rename clock reference
 to something that exists
Message-ID: <20150122093423.GA23580@griffinp-ThinkPad-X1-Carbon-2nd>
References: <1409234523-20240-1-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1409234523-20240-1-git-send-email-lee.jones@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, 28 Aug 2014, Lee Jones wrote:

> CLK_S_ICN_REG_0 hasn't existed for a while now.  This was renamed
> over a few commits, then finally removed in commit 5aa02b9 (ARM:
> STi: DT: STiH415: Remove unused CLK_S_ICN_REG_0 fixed clock).
> 
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Acked-by: Peter Griffin <peter.griffin@linaro.org>

regards,

Peter.
