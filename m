Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752380AbaJCMZh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 08:25:37 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:19335 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751314AbaJCMZd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 08:25:33 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-a6-542e95bab3f0
Message-id: <542E95BC.9000704@samsung.com>
Date: Fri, 03 Oct 2014 15:25:32 +0300
From: Dmitry Kasatkin <d.kasatkin@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.1.2
MIME-version: 1.0
To: David Howells <dhowells@redhat.com>
Cc: rusty@rustcorp.com.au, keyrings@linux-nfs.org, jwboyer@redhat.com,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        pjones@redhat.com, vgoyal@redhat.com
Subject: Re: [PATCH 08/13] KEYS: Overhaul key identification when searching for
 asymmetric keys
References: <542D77A4.5030606@samsung.com>
 <20140908153704.28301.41578.stgit@warthog.procyon.org.uk>
 <20140908153830.28301.37880.stgit@warthog.procyon.org.uk>
 <542D741D.5070109@samsung.com> <28452.1412338401@warthog.procyon.org.uk>
In-reply-to: <28452.1412338401@warthog.procyon.org.uk>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
X-Originating-IP: [106.122.1.121]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrILMWRmVeSWpSXmKPExsVy+t/xy7q7puqFGLz6om7xruk3i8WBd09Y
	LGbveshicXnXHDaLDz2P2Cy6Ft5gt7g57QKLxbVb+9gcODymnVjG4vF+31U2jxUbTjB7fN4k
	F8ASxWWTkpqTWZZapG+XwJUxfcY+toJXTBVfF69lamBcxdTFyMEhIWAi8XaxdxcjJ5ApJnHh
	3nq2LkYuDiGBpYwSG+4ug3IamSQubdoK5cxilLh0Zh8rSAuvgJZE661VLCA2i4CqxNT1J5lB
	bDYBPYkNzT/YQWxRgQiJk3f3sEPUC0r8mHwPrF5EQF3i0bKNzCBDmQW2MEo0rD3CBpIQFkiU
	mLZnBxPEtreMEhM2f2IEuZVTwEzi3QtbEJMZaMH9i1og5cwC8hKb17wF2ysEdEP32rVsEO8o
	SpyefI55AqPwLCSrZyF0z0LSvYCReRWjaGppckFxUnquoV5xYm5xaV66XnJ+7iZGSLR82cG4
	+JjVIUYBDkYlHt6PN3RDhFgTy4orcw8xSnAwK4nwSjfphQjxpiRWVqUW5ccXleakFh9iZOLg
	lGpg1GjdPzHN5f1PzvlHuZ60OR6ayneDUfPLKZvIbtWP3B0yj05nppwtEXY9lrwmufRV6r4Z
	7fdLGKu2s/AxRP1WUKx0sGBvtv4X92HNjjIDmfSS5aXzVjwWfHmub1mzZfye2mvXV5RUR19W
	m39j0/H/CeltanPcn93Oyjuqc8X0OLtXYVZcz4NVSizFGYmGWsxFxYkANsEmhHQCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/10/14 15:13, David Howells wrote:
> Dmitry Kasatkin <d.kasatkin@samsung.com> wrote:
>
>> [  132.820302] CR2: ffffffffffffffea
> Looks like I leaked an error number somewhere.
>
> David
>

Yes... I found..
Check patches I posted.

Also here
http://git.kernel.org/cgit/linux/kernel/git/kasatkin/linux-digsig.git/log/?h=keys-fixes

- Dmitry

