Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755874AbaELSyH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 14:54:07 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:52468 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752543AbaELSyE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 14:54:04 -0400
X-Sasl-enc: CCS4gfNZPiTb+ryiZoGNO9JLJcS217IDeCnjhF33Vwnp 1399920840
Message-ID: <537118C6.7050203@iki.fi>
Date: Mon, 12 May 2014 21:53:58 +0300
From: Pekka Enberg <penberg@iki.fi>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Christoph Lameter <cl@linux.com>, Jim Davis <jim.epost@gmail.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-next <linux-next@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, penberg@kernel.org,
        mpm@selenic.com, linux-mm@kvack.org
Subject: Re: randconfig build error with next-20140512, in mm/slub.c
References: <CA+r1Zhg4JzViQt=J0XBu4dRwFUZGwi52QLefkzwcwn4NUfk8Sw@mail.gmail.com> <alpine.DEB.2.10.1405121346370.30318@gentwo.org>
In-Reply-To: <alpine.DEB.2.10.1405121346370.30318@gentwo.org>
Content-Type: text/plain; charset=ISO-8859-7; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/12/2014 09:47 PM, Christoph Lameter wrote:
> A patch was posted today for this issue.

AFAICT, it's coming from -mm. Andrew, can you pick up the fix?

> Date: Mon, 12 May 2014 09:36:30 -0300
> From: Fabio Estevam <fabio.estevam@freescale.com>
> To: akpm@linux-foundation.org
> Cc: linux-mm@kvack.org, festevam@gmail.com, Fabio Estevam
> <fabio.estevam@freescale.com>,    Christoph Lameter <cl@linux.com>, David Rientjes <rientjes@google.com>, Pekka Enberg <penberg@kernel.org>
> Subject: [PATCH] mm: slub: Place count_partial() outside CONFIG_SLUB_DEBUG if block
>
>
> On Mon, 12 May 2014, Jim Davis wrote:
>
>> Building with the attached random configuration file,
>>
>> mm/slub.c: In function ¡show_slab_objects¢:
>> mm/slub.c:4361:5: error: implicit declaration of function ¡count_partial¢ [-Werr
>> or=implicit-function-declaration]
>>       x = count_partial(n, count_total);
>>       ^
>> cc1: some warnings being treated as errors
>> make[1]: *** [mm/slub.o] Error 1
> >

