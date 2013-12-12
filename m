Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751884Ab3LLAZm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 19:25:42 -0500
Received: from mail-pd0-f173.google.com ([209.85.192.173]:64804 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751791Ab3LLAZj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 19:25:39 -0500
Date: Wed, 11 Dec 2013 16:23:26 -0800
From: Olof Johansson <olof@lixom.net>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Arnd Bergmann <arnd@arndb.de>, arm@kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Yanis Moreno <yanis.moreno63@gmail.com>
Subject: Re: [PATCH] ARM: at91: remove redundant dependency
Message-ID: <20131212002326.GA21531@quad.lixom.net>
References: <1384932191-8967-1-git-send-email-michael.opdenacker@free-electrons.com>
 <1386259208-2239-1-git-send-email-nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386259208-2239-1-git-send-email-nicolas.ferre@atmel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 05, 2013 at 05:00:08PM +0100, Nicolas Ferre wrote:
> From: Yanis Moreno <yanis.moreno63@gmail.com>
> 
> This removes the "depends on SOC_SAM_V7" statement
> in a Kconfig section that's under an "if SOC_SAM_V7"
> condition (same parameter).
> 
> Signed-off-by: Yanis Moreno <yanis.moreno63@gmail.com>
> Reviewed-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> ---
> Hi Olof,
> 
> This is an additional patch for cleanup. I didn't include it in my previous
> "cleanup" branch as I had wanted to keep it focused on the move to CCF.
> 
> As you said that you are okay with applying patches and that I have only one
> related to "cleanup" for the moment, I send it to you.

Applied. Thanks.

-Olof
