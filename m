Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753930Ab3LRJX2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 04:23:28 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:57735 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752286Ab3LRJXJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 04:23:09 -0500
Date: Wed, 18 Dec 2013 09:23:05 +0000
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: Mark Brown <broonie@kernel.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        linaro-kernel@lists.linaro.org, Mark Brown <broonie@linaro.org>,
        linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com
Subject: Re: [PATCH] mfd: wm8994: Allow modular build
Message-ID: <20131218092305.GC11138@opensource.wolfsonmicro.com>
References: <1387322991-13092-1-git-send-email-broonie@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1387322991-13092-1-git-send-email-broonie@kernel.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 17, 2013 at 11:29:51PM +0000, Mark Brown wrote:
> From: Mark Brown <broonie@linaro.org>
> 
> The interfaces that used to be built in only (interrupts IIRC) no longer
> are so allow the driver to be built as a module fixing arm64 allmodconfig
> builds.
> 
> Signed-off-by: Mark Brown <broonie@linaro.org>
> ---

Acked-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>

Thanks,
Charles
