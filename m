Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758534AbaELVv0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 17:51:26 -0400
Received: from mail-vc0-f182.google.com ([209.85.220.182]:46121 "EHLO
	mail-vc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758300AbaELVvY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 17:51:24 -0400
MIME-Version: 1.0
In-Reply-To: <537118C6.7050203@iki.fi>
References: <CA+r1Zhg4JzViQt=J0XBu4dRwFUZGwi52QLefkzwcwn4NUfk8Sw@mail.gmail.com>
	<alpine.DEB.2.10.1405121346370.30318@gentwo.org>
	<537118C6.7050203@iki.fi>
Date: Mon, 12 May 2014 18:51:23 -0300
Message-ID: <CAOMZO5CUxrYk2WAHcwSmaHt55qkadopkdpJo+pq28m0XwUz4Vg@mail.gmail.com>
Subject: Re: randconfig build error with next-20140512, in mm/slub.c
From: Fabio Estevam <festevam@gmail.com>
To: Pekka Enberg <penberg@iki.fi>
Cc: Christoph Lameter <cl@linux.com>, Jim Davis <jim.epost@gmail.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-next <linux-next@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, penberg@kernel.org,
        Matt Mackall <mpm@selenic.com>, linux-mm@kvack.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 12, 2014 at 3:53 PM, Pekka Enberg <penberg@iki.fi> wrote:
> On 05/12/2014 09:47 PM, Christoph Lameter wrote:
>>
>> A patch was posted today for this issue.
>
>
> AFAICT, it's coming from -mm. Andrew, can you pick up the fix?

It seems that Andrew has fixed it already:
http://marc.info/?l=linux-mm-commits&m=139992385527040
