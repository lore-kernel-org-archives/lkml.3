Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752622Ab3AVHVx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 02:21:53 -0500
Received: from mail-pa0-f53.google.com ([209.85.220.53]:38030 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751003Ab3AVHVv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 02:21:51 -0500
Date: Mon, 21 Jan 2013 23:21:56 -0800
From: Olof Johansson <olof@lixom.net>
To: Tony Prisk <linux@prisktech.co.nz>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        vt8500-wm8505-linux-kernel@lists.infradead.org, arm@kernel.org
Subject: Re: [PATCH] dts: vt8500: Add initial dts support for WM8850
Message-ID: <20130122072156.GC25783@quad.lixom.net>
References: <1358577868-29042-1-git-send-email-linux@prisktech.co.nz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1358577868-29042-1-git-send-email-linux@prisktech.co.nz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 19, 2013 at 07:44:28PM +1300, Tony Prisk wrote:
> This patch adds a soc dtsi for the Wondermedia WM8850.
> 
> A board dts file is also included for the W70v2 tablet, with support
> for all the drivers currently in mainline.
> 
> Signed-off-by: Tony Prisk <linux@prisktech.co.nz>
> ---
> Hi Olof,
> 
> Sorry this is a bit late.

For 3.9? No worries, not late yet.

I've applied this to the same branch as the other wm8x50 patches. I also fixed
up three <space><tab> occurrances in the dtsi that git am complained about.


-Olof
