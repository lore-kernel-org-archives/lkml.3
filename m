Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754835Ab3CRUTn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 16:19:43 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45264 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751903Ab3CRUTm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 16:19:42 -0400
Date: Mon, 18 Mar 2013 13:19:40 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH 2/2] relay: move FIX_SIZE macro into relay.c
Message-Id: <20130318131940.a2a7f04455d35ebeb899c6e4@linux-foundation.org>
In-Reply-To: <5146814A.4010200@huawei.com>
References: <5146814A.4010200@huawei.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Mar 2013 10:51:54 +0800 "zhangwei(Jovi)" <jovi.zhangwei@huawei.com> wrote:

> +/* Needs a _much_ better name... */
> +#define FIX_SIZE(x) ((((x) - 1) & PAGE_MASK) + PAGE_SIZE)
> +

Gad.  That's the same as PAGE_ALIGN(), is it not?
