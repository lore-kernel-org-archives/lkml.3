Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932982Ab3DBRU6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 13:20:58 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:37590 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932919Ab3DBRUj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 13:20:39 -0400
Date: Tue, 2 Apr 2013 10:20:36 -0700
From: Olof Johansson <olof@lixom.net>
To: Tony Prisk <linux@prisktech.co.nz>
Cc: linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk,
        linux-kernel@vger.kernel.org, arnd@arndb.de
Subject: Re: [PATCH] arm: vt8500: Add wm8850 config options to
 multi_v7_defconfig
Message-ID: <20130402172036.GG25867@quad.lixom.net>
References: <1364199100-12300-1-git-send-email-linux@prisktech.co.nz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1364199100-12300-1-git-send-email-linux@prisktech.co.nz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 25, 2013 at 09:11:40PM +1300, Tony Prisk wrote:
> This patch finally adds the WM8850 SoC to the multi_v7_defconfig.
> We don't have a seperate defconfig for this SoC as it is only
> available as a multiplatform option.
> 
> Signed-off-by: Tony Prisk <linux@prisktech.co.nz>


Applied to next/multiplatform after fixing up some conflicts due to the SPEAR
additions.


-Olof
