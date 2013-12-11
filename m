Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751879Ab3LKC4D (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 21:56:03 -0500
Received: from terminus.zytor.com ([198.137.202.10]:55965 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750782Ab3LKCz6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 21:55:58 -0500
Message-ID: <52A7D415.6010908@zytor.com>
Date: Tue, 10 Dec 2013 18:55:17 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Xishi Qiu <qiuxishi@huawei.com>, Yinghai Lu <yinghai@kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        the arch/x86 maintainers <x86@kernel.org>, Linn Crosetto <linn@hp.com>,
        Pekka Enberg <penberg@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux MM <linux-mm@kvack.org>
Subject: Re: [PATCH] mm,x86: fix span coverage in e820_all_mapped()
References: <52A6D9B0.7040506@huawei.com> <CAE9FiQUd+sU4GEq0687u8+26jXJiJVboN90+L7svyosmm+V1Rg@mail.gmail.com> <52A7C16A.9040106@huawei.com>
In-Reply-To: <52A7C16A.9040106@huawei.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/10/2013 05:35 PM, Xishi Qiu wrote:
> 
> In this case, old code is right, but I discuss in another one that
> you wrote above.
> 

So is there a problem or not?  I have lost track...

	-hpa


