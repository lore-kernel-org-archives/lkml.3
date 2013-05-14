Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757584Ab3ENRtZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 13:49:25 -0400
Received: from server.prisktech.co.nz ([115.188.14.127]:51903 "EHLO
	server.prisktech.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756472Ab3ENRtX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 13:49:23 -0400
Message-ID: <5192792C.4040004@prisktech.co.nz>
Date: Wed, 15 May 2013 05:49:32 +1200
From: Tony Prisk <linux@prisktech.co.nz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: Laurent Navet <laurent.navet@gmail.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Stephen Warren <swarren@nvidia.com>, Olof Johansson <olof@lixom.net>,
        Axel Lin <axel.lin@ingics.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] drivers: pinctrl: vt8500: use devm_ioremap_resource()
References: <1368370791-32630-1-git-send-email-laurent.navet@gmail.com> <CACRpkdbbDzudp_W0d1VW1NCMUTHA25v2N3rXopQ+_zGrQB9AyQ@mail.gmail.com>
In-Reply-To: <CACRpkdbbDzudp_W0d1VW1NCMUTHA25v2N3rXopQ+_zGrQB9AyQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15/05/13 00:52, Linus Walleij wrote:
> On Sun, May 12, 2013 at 4:59 PM, Laurent Navet <laurent.navet@gmail.com> wrote:
>
>> Replace a call to deprecated devm_request_and_ioremap by devm_ioremap_resource.
> Oh is that deprecated? I had no clue :-/
> Can you point to some rationale about this so I'm not
> totally misguided in my world..?
>
>> Found with coccicheck and this semantic patch:
>>   scripts/coccinelle/api/devm_ioremap_resource.cocci
>>
>> Signed-off-by: Laurent Navet <laurent.navet@gmail.com>
> Seems OK if the deprecation is ongoing.
> Tony can I have your ACK?
Acked-by: Tony Prisk <linux@prisktech.co.nz>
