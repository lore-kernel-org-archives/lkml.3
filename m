Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752646Ab3GGQDu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jul 2013 12:03:50 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:46564 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751547Ab3GGQDt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jul 2013 12:03:49 -0400
MIME-Version: 1.0
In-Reply-To: <0000013f9b89c37f-5d9539bc-944c-4937-9b35-30cdd0fd18a3-000000@email.amazonses.com>
References: <1372177015-30492-1-git-send-email-michael.opdenacker@free-electrons.com>
	<0000013f9b89c37f-5d9539bc-944c-4937-9b35-30cdd0fd18a3-000000@email.amazonses.com>
Date: Sun, 7 Jul 2013 19:03:47 +0300
X-Google-Sender-Auth: nrSmeww8H1g9ESFA3n9Ah5O4G3E
Message-ID: <CAOJsxLEVOgSh8x+jwjJ8EwT-U1ZiYnT71s=BrM+e6i1D3ESRXA@mail.gmail.com>
Subject: Re: [PATCH] slab: add kmalloc() to kernel API documentation
From: Pekka Enberg <penberg@kernel.org>
To: Christoph Lameter <cl@linux.com>
Cc: Michael Opdenacker <michael.opdenacker@free-electrons.com>,
        Matt Mackall <mpm@selenic.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 1, 2013 at 9:41 PM, Christoph Lameter <cl@linux.com> wrote:
> On Tue, 25 Jun 2013, Michael Opdenacker wrote:
>
>> This patch is a proposed fix for this. It also removes the documentation
>> for kmalloc() in include/linux/slob_def.h which isn't included to
>> generate the documentation anyway. This way, kmalloc() is described
>> in only one place.
>
> Acked-by: Christoph Lameter <cl@linux.com>

Applied, thanks!
