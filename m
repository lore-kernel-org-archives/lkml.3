Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756597Ab3BFPuj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 10:50:39 -0500
Received: from mail-ie0-f173.google.com ([209.85.223.173]:46356 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754896Ab3BFPuh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 10:50:37 -0500
Message-ID: <51127BCA.7070900@mojatatu.com>
Date: Wed, 06 Feb 2013 10:50:34 -0500
From: Jamal Hadi Salim <jhs@mojatatu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Emmanuel Thierry <emmanuel.thierry@telecom-bretagne.eu>
CC: Steffen Klassert <steffen.klassert@secunet.com>,
        Romain KUNTZ <r.kuntz@ipflavors.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        herbert@gondor.hengli.com.au,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jamal Hadi Salim <hadi@cyberus.ca>
Subject: Re: [RFC PATCH] xfrm: fix handling of XFRM policies mark and mask.
References: <9E57ADA1-5770-47A8-8EBF-7FC262EEF1C7@ipflavors.com> <20130205081232.GF23291@secunet.com> <51125744.3030905@gmail.com> <D4563759-CEC5-4F33-BF0A-9FA10716F8DF@telecom-bretagne.eu> <511268F0.5070808@mojatatu.com> <5D4F2414-B869-46AA-B684-01F9EA88AD03@telecom-bretagne.eu>
In-Reply-To: <5D4F2414-B869-46AA-B684-01F9EA88AD03@telecom-bretagne.eu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13-02-06 09:39 AM, Emmanuel Thierry wrote:
>

> I think you misread the example !

I did ;->

> Marks are both 1, masks are different.
>
> This case is more complex than a policy
> with no mark (so mark=0 and mask=0) versus
> a policy with an exact mark (so mark=1 and mask=0xffffffff),
> and i wanted to know if the algorithm would take these kind of cases into account.
>

Aha. I think this is pushing the envelope a little - are there good use 
cases for this?
certainly you could insert with most exact mask first. No such check is 
made at the moment.

cheers,
jamal
