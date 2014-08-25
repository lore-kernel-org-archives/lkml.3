Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933327AbaHYTK2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 15:10:28 -0400
Received: from arrakis.dune.hu ([78.24.191.176]:47089 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933124AbaHYTK1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 15:10:27 -0400
MIME-Version: 1.0
In-Reply-To: <20140825112754.GE27724@linux-mips.org>
References: <1408818808-18850-1-git-send-email-Julia.Lawall@lip6.fr>
 <1408818808-18850-5-git-send-email-Julia.Lawall@lip6.fr> <20140825112754.GE27724@linux-mips.org>
From: Jonas Gorski <jogo@openwrt.org>
Date: Mon, 25 Aug 2014 21:09:53 +0200
Message-ID: <CAOiHx=m_-GmRwAmPOWFg8w9pFMPU8Vn9U-UO+k=jDdDxNH7R3Q@mail.gmail.com>
Subject: Re: [PATCH 4/7] MIPS: BCM63xx: delete double assignment
To: Ralf Baechle <ralf@linux-mips.org>
Cc: Julia Lawall <Julia.Lawall@lip6.fr>, joe@perches.com,
        kernel-janitors@vger.kernel.org,
        MIPS Mailing List <linux-mips@linux-mips.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 25, 2014 at 1:27 PM, Ralf Baechle <ralf@linux-mips.org> wrote:
> On Sat, Aug 23, 2014 at 08:33:25PM +0200, Julia Lawall wrote:
>
>> Delete successive assignments to the same location.  In each case, the
>> duplicated assignment is modified to be in line with other nearby code.
>>
>> A simplified version of the semantic match that finds this problem is as
>> follows: (http://coccinelle.lip6.fr/)
>
> Looking good, applied.

Huh, somehow gmail decided the original emails were spam.

> Thanks,
>
>   Ralf

Also thanks from me for cleaning up behind me! These mistakes were
definitely mine.


Jonas
