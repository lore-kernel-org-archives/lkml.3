Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751999Ab3DMFkm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Apr 2013 01:40:42 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:54227 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751275Ab3DMFkl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Apr 2013 01:40:41 -0400
Date: Fri, 12 Apr 2013 22:40:41 -0700
From: Olof Johansson <olof@lixom.net>
To: Tony Prisk <linux@prisktech.co.nz>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        vt8500-wm8505-linux-kernel@googlegroups.com
Subject: Re: [PATCH] arm: vt8500: Add SDHC support to WM8505 DT
Message-ID: <20130413054041.GA12845@quad.lixom.net>
References: <1365706829-9626-1-git-send-email-linux@prisktech.co.nz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1365706829-9626-1-git-send-email-linux@prisktech.co.nz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 12, 2013 at 07:00:29AM +1200, Tony Prisk wrote:
> This patch adds the required node for the SDHC controller on WM8505 SoCs.
> 
> Signed-off-by: Tony Prisk <linux@prisktech.co.nz>
> ---
> Arnd,
> 
> Any chance you can apply this for 3.10

Applied to next/dt


-Olof
