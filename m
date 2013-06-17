Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755696Ab3FQBOS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jun 2013 21:14:18 -0400
Received: from intranet.asianux.com ([58.214.24.6]:15836 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750959Ab3FQBOR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jun 2013 21:14:17 -0400
X-Spam-Score: -100.8
Message-ID: <51BE62B5.1010302@asianux.com>
Date: Mon, 17 Jun 2013 09:13:25 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Mike Frysinger <vapier@gentoo.org>
CC: anton.vorontsov@linaro.org, Richard Kuo <rkuo@codeaurora.org>,
        Jesper Nilsson <jesper.nilsson@axis.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Miller <davem@davemloft.net>,
        "uclinux-dist-devel@blackfin.uclinux.org" 
	<uclinux-dist-devel@blackfin.uclinux.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux-Arch <linux-arch@vger.kernel.org>
Subject: Re: [PATCH] arch: blackfin: kernel: sprintf(), need avoid NUL for
 '%s'
References: <51A5CDB4.9000204@asianux.com> <CAMjpGUf6rvcjNVqk6bB4RRjOSLQjk3de6CEv7rUm3VcMhzGdag@mail.gmail.com>
In-Reply-To: <CAMjpGUf6rvcjNVqk6bB4RRjOSLQjk3de6CEv7rUm3VcMhzGdag@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/16/2013 11:02 AM, Mike Frysinger wrote:
> i think you mean NULL instead of NUL
> 
> that said, the kernel is smart enough to replace NULL with "(null)",
> so i don't see much point in this patch

Oh, really it is, it is my fault (originally, I did not know about it).

Thanks.
-- 
Chen Gang

Asianux Corporation
