Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757201Ab3DAJNh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 05:13:37 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:21459 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757002Ab3DAJNg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 05:13:36 -0400
Date: Mon, 1 Apr 2013 12:13:17 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Haksu Jeong <hsjeong@snu.ac.kr>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: rtl8192u: fix coding style
Message-ID: <20130401091317.GP9138@mwanda>
References: <CAFyudig8ak-q+0LtrfG_we57UFM6RymhFdhggcEcqHpTg76rew@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFyudig8ak-q+0LtrfG_we57UFM6RymhFdhggcEcqHpTg76rew@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 27, 2013 at 08:20:11PM +0900, Haksu Jeong wrote:
> Fix coding style of r8192U_dm.h
> 

This patch is white space damaged and doesn't apply.

Save the raw patch as text (including headers and everything).

cat my_patch.txt | git am

Fails.

Probably it's better to split this up and send it as several
patches.

[patch 1/3] Staging: rtl8192u: r8192U_dm.h: use c99 comments
[patch 2/3] Staging: rtl8192u: r8192U_dm.h: use proper white space
[patch 3/3] Staging: rtl8192u: r8192U_dm.h: reposition the braces

regards,
dan carpenter

