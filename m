Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752131AbaAOCvt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 21:51:49 -0500
Received: from mail-yh0-f53.google.com ([209.85.213.53]:48753 "EHLO
	mail-yh0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751503AbaAOCvq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 21:51:46 -0500
Message-ID: <52D5F7BF.7090407@gmail.com>
Date: Tue, 14 Jan 2014 21:51:43 -0500
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>, Eric Dumazet <eric.dumazet@gmail.com>
CC: Hannes Frederic Sowa <hannes@stressinduktion.org>, netdev@vger.kernel.org,
        dborkman@redhat.com, linux-kernel@vger.kernel.org,
        darkjames-ws@darkjames.pl
Subject: Re: [PATCH RFC] reciprocal_divide: correction/update of the algorithm
References: <20140113214249.GK6586@order.stressinduktion.org> <1389722825.31367.260.camel@edumazet-glaptop2.roam.corp.google.com> <52D58E6F.4050000@gmail.com> <1389729032.31367.262.camel@edumazet-glaptop2.roam.corp.google.com> <52D5A3DC.9030107@gmail.com> <1389739537.31367.273.camel@edumazet-glaptop2.roam.corp.google.com> <20140114232538.GD29887@pd.tnic>
In-Reply-To: <20140114232538.GD29887@pd.tnic>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 01/14/2014 06:25 PM, Borislav Petkov wrote:
> On Tue, Jan 14, 2014 at 02:45:37PM -0800, Eric Dumazet wrote:
>> Even on a Jaguar, the proposed alternative
> I don't know what Jaguar you guys are talking about but the Jaguar
> I know - Fam16h - has an int hardware divider:
>
> http://developer.amd.com/wordpress/media/2012/10/SOG_16h_52128_PUB_Rev1_1.pdf
>
> So all that talk about microcode is plain wrong. The hardware divider
> comes from Llano (F12h) so it must be some other Jaguar, maybe Bobcat.
>
> :-)
>
> If it is Bobcat, then it has a 1-bit per cycle ucode int divider.
>
Apologies, it does have a hardware divider, however it still only gets 2
bits per cycle.
