Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754747AbaJHPQU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 11:16:20 -0400
Received: from mail-ig0-f169.google.com ([209.85.213.169]:60966 "EHLO
	mail-ig0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750858AbaJHPQS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 11:16:18 -0400
MIME-Version: 1.0
In-Reply-To: <1412780019-32475-1-git-send-email-standby24x7@gmail.com>
References: <1412780019-32475-1-git-send-email-standby24x7@gmail.com>
Date: Wed, 8 Oct 2014 08:16:16 -0700
Message-ID: <CAPcyv4hn7oJ7tpZFX9GDOpRku_w=CA0rhU+r=_dn_xYyn3_kCg@mail.gmail.com>
Subject: Re: [PATCH] net: description of dma_cookie cause make xmldocs warning
From: Dan Williams <dan.j.williams@intel.com>
To: Masanari Iida <standby24x7@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>, Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 8, 2014 at 7:53 AM, Masanari Iida <standby24x7@gmail.com> wrote:
> In commit 7bced397510ab569d31de4c70b39e13355046387,
> dma_cookie was removed from struct skbuff.
> But the description of dma_cookie still exist.
> So the "make xmldocs" output following warning.
>
> Warning(.//include/linux/skbuff.h:609): Excess struct/union
> /enum/typedef member 'dma_cookie' description in 'sk_buff'
>
> Remove description of dma_cookie fix the symptom.
>
> Signed-off-by: Masanari Iida <standby24x7@gmail.com>

Acked-by: Dan Williams <dan.j.williams@intel.com>
