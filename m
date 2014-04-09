Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932634AbaDIH1P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 03:27:15 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:42376 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750814AbaDIH1O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 03:27:14 -0400
Date: Wed, 9 Apr 2014 00:27:10 -0700
From: Brian Norris <computersforpeace@gmail.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kernel@stlinux.com, linux-mtd@lists.infradead.org, angus.clark@st.com
Subject: Re: [PATCH 00/15] mtd: st_spi_fsm: Align with ST's internal
 development
Message-ID: <20140409072710.GF3131@norris-Latitude-E6410>
References: <1395851969-13520-1-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1395851969-13520-1-git-send-email-lee.jones@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 26, 2014 at 04:39:14PM +0000, Lee Jones wrote:
> This patch-set updates ST's FSM SPI-NOR driver with all the internal
> goodness which has happened since the initial (now upstreamed) snapshot
> was taken. It covers just over 6 months worth of internal development
> and bug-fixes. A final whitespace clean-up is also appended to the set
> - to make it look pretty and stuff. :)

I applied the first 6 to l2-mtd.git/spinor. Please rebase the others so
they can apply, and address the DT comment I sent.

Thanks,
Brian
