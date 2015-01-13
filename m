Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753463AbbAMEEq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 23:04:46 -0500
Received: from mail-yh0-f42.google.com ([209.85.213.42]:37052 "EHLO
	mail-yh0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753205AbbAMEEp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 23:04:45 -0500
Date: Mon, 12 Jan 2015 20:04:41 -0800
From: Brian Norris <computersforpeace@gmail.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mtd@lists.infradead.org, kernel@stlinux.com
Subject: Re: [PATCH v3 11/13] mtd: st_spi_fsm: General tidy-up
Message-ID: <20150113040441.GL9759@ld-irv-0074>
References: <1418644760-18773-1-git-send-email-lee.jones@linaro.org>
 <1418644760-18773-12-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1418644760-18773-12-git-send-email-lee.jones@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 15, 2014 at 11:59:18AM +0000, Lee Jones wrote:
> Due to the nature of the port (lots of copy/paste) much of the white-space
> is taken up by spaces instead of tab separators. This patch aims to change
> that.
> 
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

checkpatch.pl gives several warnings like this on this patch:

    WARNING:SPACE_BEFORE_TAB: please, no space before tabs

Please consider fixing them up.

Brian
