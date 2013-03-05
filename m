Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752747Ab3CEXNZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 18:13:25 -0500
Received: from mail-oa0-f47.google.com ([209.85.219.47]:40544 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751163Ab3CEXNY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 18:13:24 -0500
MIME-Version: 1.0
In-Reply-To: <1362521809-22989-10-git-send-email-arnd@arndb.de>
References: <1362521809-22989-1-git-send-email-arnd@arndb.de>
	<1362521809-22989-10-git-send-email-arnd@arndb.de>
Date: Wed, 6 Mar 2013 07:13:23 +0800
Message-ID: <CAKohponFisFjM9CbpHoR7h-pn1SAOWeck63v3FKZe4UV0cR2DQ@mail.gmail.com>
Subject: Re: [PATCH 9/9] ARM: spear3xx: Use correct pl080 header file
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        arm@kernel.org, Alessandro Rubini <rubini@gnudd.com>,
        spear-devel <spear-devel@list.st.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6 March 2013 06:16, Arnd Bergmann <arnd@arndb.de> wrote:
> The definitions have move around recently, causing build errors
> in spear3xx for all configurations:
>
> spear3xx.c:47:5: error: 'PL080_BSIZE_16' undeclared here (not in a function)
> spear3xx.c:47:23: error: 'PL080_CONTROL_SB_SIZE_SHIFT' undeclared here (not in a function)
> spear3xx.c:48:22: error: 'PL080_CONTROL_DB_SIZE_SHIFT' undeclared here (not in a function)
>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Alessandro Rubini <rubini@gnudd.com>
> Cc: Viresh Kumar <viresh.kumar@linaro.org>
> ---
>  arch/arm/mach-spear3xx/spear3xx.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

You are a bit late in posting this.
We already got the same patch from Vipul yesterday :)
