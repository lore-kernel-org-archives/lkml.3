Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754762AbaAFLkJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 06:40:09 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:49801 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753655AbaAFLkI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 06:40:08 -0500
Date: Mon, 6 Jan 2014 11:40:03 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-kernel@vger.kernel.org, patches@linaro.org
Subject: Re: [PATCH] mfd: Cleanup mfd-mcp-sa11x0.h header
Message-ID: <20140106114002.GQ23772@lee--X1>
References: <1388384696-24291-1-git-send-email-sachin.kamat@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1388384696-24291-1-git-send-email-sachin.kamat@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Dec 2013, Sachin Kamat wrote:

> Commit a1fd844c6e62 ("ARM: sa1100: move platform_data definitions")
> moved the file to the current location but forgot to remove the pointer
> to its previous location. Clean it up. While at it also change the header
> file protection macros appropriately.
> 
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
> ---
>  include/linux/platform_data/mfd-mcp-sa11x0.h |    6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)

Applied, thanks.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
