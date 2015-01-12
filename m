Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751612AbbALISo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 03:18:44 -0500
Received: from a.ns.miles-group.at ([95.130.255.143]:65276 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751281AbbALISm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 03:18:42 -0500
Message-ID: <54B3834D.6090602@nod.at>
Date: Mon, 12 Jan 2015 09:18:21 +0100
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: joe@perches.com, coreteam@netfilter.org, netfilter-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bhutchings@solarflare.com, john.fastabend@gmail.com,
        herbert@gondor.apana.org.au, vyasevic@redhat.com, jiri@resnulli.us,
        vfalico@gmail.com, therbert@google.com, edumazet@google.com,
        yoshfuji@linux-ipv6.org, jmorris@namei.org, kuznet@ms2.inr.ac.ru,
        kadlec@blackhole.kfki.hu, kaber@trash.net, pablo@netfilter.org,
        kay@vrfy.org, stephen@networkplumber.org
Subject: Re: [PATCH 3/3] x_tables: Factor out 16bit aligment ifname_compare()
References: <54B2EB81.5050604@nod.at>	<1421012376.9233.9.camel@perches.com>	<54B2EE4D.2080802@nod.at> <20150111.215050.458358747958425038.davem@davemloft.net>
In-Reply-To: <20150111.215050.458358747958425038.davem@davemloft.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 12.01.2015 um 03:50 schrieb David Miller:
> From: Richard Weinberger <richard@nod.at>
> Date: Sun, 11 Jan 2015 22:42:37 +0100
> 
>> Joe, I really don't care. This is the least significant
>> patch of the series.
>> I'll no longer waste my time with that.
> 
> If you're not willing to fix stylistic issues now, then nobody should
> bother wasting their time on the high level issues of your patch.
> 
> Just fix these things now rather than being difficult, this is a part
> of patch review that everyone has to do, not just you.

I apologize, it was not my intention to be difficult.
Please note that the stylistic issue is not a warning produced
by checkpatch.pl. If you and netfilter folks now prefer bool
for such string compare functions I'll happily address this in
v2 of my series.

Thanks,
//richard
