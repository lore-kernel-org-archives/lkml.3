Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753138AbaJMFzh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 01:55:37 -0400
Received: from mail-ig0-f172.google.com ([209.85.213.172]:37902 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752429AbaJMFzg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 01:55:36 -0400
Message-ID: <543B6952.6010200@gmail.com>
Date: Mon, 13 Oct 2014 13:55:30 +0800
From: hejianet <hejianet@gmail.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] staging: rtl8188eu: Fix coding style space missing
 problems
References: <1412845387-17668-1-git-send-email-hejianet@gmail.com>	 <1412862833-19015-1-git-send-email-hejianet@gmail.com>	 <1412862833-19015-2-git-send-email-hejianet@gmail.com> <1412865359.3438.55.camel@joe-AO725>
In-Reply-To: <1412865359.3438.55.camel@joe-AO725>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 Thanks for the suggestion, I will update it later

On Thu, 09 Oct 2014 07:35:59 -0700 from joe@perches.com wrote:
> git ls-files "drivers/staging/rtl8188eu/*.[ch]" | \
>   xargs ./scripts/checkpatch.pl -f --fix-inplace --strict --types=SPACING

