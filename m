Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751621AbaAXCHt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 21:07:49 -0500
Received: from mail-pd0-f170.google.com ([209.85.192.170]:45729 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750969AbaAXCHr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 21:07:47 -0500
Date: Thu, 23 Jan 2014 18:05:51 -0800
From: Olof Johansson <olof@lixom.net>
To: Jonas Jensen <jonas.jensen@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, arm@kernel.org, linux@arm.linux.org.uk,
        arnd@arndb.de, soren.brinkmann@xilinx.com,
        peter.crosthwaite@xilinx.com
Subject: Re: [PATCH] ARM: moxart: move fixed rate clock child node to board
 level dts
Message-ID: <20140124020551.GA17877@quad.lixom.net>
References: <1389886746-972-1-git-send-email-jonas.jensen@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389886746-972-1-git-send-email-jonas.jensen@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 16, 2014 at 04:39:06PM +0100, Jonas Jensen wrote:
> When a skeleton "clocks { .. }" remain in .dtsi, the child node can
> be moved to .dts, "ref12" is then found by of_clk_get().
> 
> Signed-off-by: Jonas Jensen <jonas.jensen@gmail.com>

Applied to late/misc branch, will likely be included in 3.14-rc1


-Olof
