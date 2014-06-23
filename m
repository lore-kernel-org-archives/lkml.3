Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751504AbaFWB3v (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2014 21:29:51 -0400
Received: from mail-pb0-f54.google.com ([209.85.160.54]:42237 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751154AbaFWB3t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2014 21:29:49 -0400
Message-ID: <53A78305.6000108@gmail.com>
Date: Mon, 23 Jun 2014 09:29:41 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: anton@tuxera.com, linux-ntfs-dev@lists.sourceforge.net,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Liqin Chen <liqin.linux@gmail.com>, Lennox Wu <lennox.wu@gmail.com>
Subject: Re: [PATCH] fs/ntfs: Use '%lx' instead of '%zx'
References: <53A649FB.3090808@gmail.com> <1403417177.4076.54.camel@joe-AO725>
In-Reply-To: <1403417177.4076.54.camel@joe-AO725>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/22/2014 02:06 PM, Joe Perches wrote:
> On Sun, 2014-06-22 at 11:14 +0800, Chen Gang wrote:
>> For subtraction between 2 pointers, the result's type is 'long', so
>> need use '%lx' instead of '%zx'.
> 
> result should be a ptrdiff_t so please use %tx
> 

OK, thanks, I shall send patch v2 for it.

Thanks.
-- 
Chen Gang

Open, share, and attitude like air, water, and life which God blessed
