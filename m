Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759718Ab3GaNZk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 09:25:40 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44022 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759640Ab3GaNZg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 09:25:36 -0400
Message-ID: <51F91030.9060606@zytor.com>
Date: Wed, 31 Jul 2013 06:25:04 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Mike Rapoport <mike.rapoport@gmail.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Ramkumar Ramachandra <artagnon@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [QUERY] lguest64
References: <CALkWK0n7zedKD4tnxKh-qMuDnMJ5RXjnPJ9EUWT=cCgiokX11A@mail.gmail.com> <51E97779.3020103@zytor.com> <87zjte9iah.fsf@rustcorp.com.au> <CABpLfohrweJd0=0eFJDO7dv2HHxx_mbP0uySMDrsZZZXExdXug@mail.gmail.com> <51F9005F.30501@zytor.com> <20130731131757.GB22124@phenom.dumpdata.com>
In-Reply-To: <20130731131757.GB22124@phenom.dumpdata.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/31/2013 06:17 AM, Konrad Rzeszutek Wilk wrote:
>>
>> The big problem with pvops is that they are a permanent tax on future
>> development -- a classic case of "the hooks problem."  As such it is
>> important that there be a real, significant, use case with enough users
>> to make the pain worthwhile.  With Xen looking at sunsetting PV support
>> with a long horizon, it might currently be possible to remove pvops some
> 
> PV MMU parts specifically.
> 

Pretty much stuff that is driverized on plain hardware doesn't matter.
What are you looking at with respect to the basic CPU control state?

	-hpa


