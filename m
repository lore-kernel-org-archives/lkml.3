Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751358Ab3LKUat (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 15:30:49 -0500
Received: from terminus.zytor.com ([198.137.202.10]:38314 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750922Ab3LKUar (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 15:30:47 -0500
Message-ID: <52A8CB45.2080704@zytor.com>
Date: Wed, 11 Dec 2013 12:29:57 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Zhouyi Zhou <zhouzhouyi@gmail.com>, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, mingo@redhat.com, x86@kernel.org, bp@alien8.de,
        keescook@chromium.org, zhangyanfei@cn.fujitsu.com
CC: Zhouyi Zhou <yizhouzhou@ict.ac.cn>
Subject: Re: [RFC PATCH] x86_64: double the x86_64 kernel stack size?
References: <1386743332-32171-1-git-send-email-yizhouzhou@ict.ac.cn>
In-Reply-To: <1386743332-32171-1-git-send-email-yizhouzhou@ict.ac.cn>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/10/2013 10:28 PM, Zhouyi Zhou wrote:
> Somethings I compiled the Linux network modules (especially bridge and netfilter)
> without optimization, the kernel always crashes because of exhausted kernel stack.
> 
> The similar problem has been discussed in
> http://lists.linuxfoundation.org/pipermail/bridge/2005-January/004402.html
> 
> Is it OK the double the x86_64 kernel stack size?
>  

Hell no.

	-hpa

