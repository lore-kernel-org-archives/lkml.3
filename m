Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751146Ab3HTMFU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 08:05:20 -0400
Received: from mail-ea0-f173.google.com ([209.85.215.173]:50556 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750907Ab3HTMFT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 08:05:19 -0400
Date: Tue, 20 Aug 2013 13:05:14 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Florian Lobmaier <florian.lobmaier@ams.com>
Cc: linux-kernel@vger.kernel.org, sameo@linux.intel.com
Subject: Re: [PATCH 3/4] mfd: as3722: introduce platform and register include
 files
Message-ID: <20130820120514.GM23699@lee--X1>
References: <1376997210-32631-1-git-send-email-florian.lobmaier@ams.com>
 <1376997210-32631-4-git-send-email-florian.lobmaier@ams.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1376997210-32631-4-git-send-email-florian.lobmaier@ams.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Aug 2013, Florian Lobmaier wrote:

> 
> Signed-off-by: Florian Lobmaier <florian.lobmaier@ams.com>
> ---
>  include/linux/mfd/as3722-plat.h |  238 +++++++++++++++++++
>  include/linux/mfd/as3722-reg.h  |  495 +++++++++++++++++++++++++++++++++++++++
>  2 files changed, 733 insertions(+), 0 deletions(-)
>  create mode 100644 include/linux/mfd/as3722-plat.h
>  create mode 100644 include/linux/mfd/as3722-reg.h

Again, patches need to be orthogonal. If I were to apply patches 1 and
2, but leave out 3 and 4, it wouldn't build would it? You should add
these header files when you start referencing them from your *.c
files. At the very least, they should go in *before* you start to use
them.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
