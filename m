Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753973Ab3AZOY2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2013 09:24:28 -0500
Received: from mail-qc0-f174.google.com ([209.85.216.174]:53469 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751746Ab3AZOY0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2013 09:24:26 -0500
MIME-Version: 1.0
In-Reply-To: <201301261348.36135.arnd@arndb.de>
References: <1359163872-1949-1-git-send-email-tj@kernel.org>
	<1359163872-1949-15-git-send-email-tj@kernel.org>
	<201301261348.36135.arnd@arndb.de>
Date: Sat, 26 Jan 2013 06:24:25 -0800
X-Google-Sender-Auth: 84Tz6SiPuz-Mt1Cr7cxILRe76Zw
Message-ID: <CAOS58YMCbP1=kzm9zMbWygKaukmagc0eUmcUH2vcXF5Ofcs5Aw@mail.gmail.com>
Subject: Re: [PATCH 14/14] idr: deprecate idr_remove_all()
From: Tejun Heo <tj@kernel.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: akpm@linux-foundation.org, rusty@rustcorp.com.au,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Arnd.

On Sat, Jan 26, 2013 at 5:48 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> If all in-kernel users are gone, why not just remove the function
> completely?

Out of pure kindness of my heart for the sad folks without the grace
of mainline. I was thinking to kill it in a release cycle or two.

Thanks.

-- 
tejun
