Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754074AbaGUUXr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 16:23:47 -0400
Received: from terminus.zytor.com ([198.137.202.10]:46395 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750821AbaGUUXq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 16:23:46 -0400
Message-ID: <53CD7694.9010008@zytor.com>
Date: Mon, 21 Jul 2014 13:22:44 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Toshi Kani <toshi.kani@hp.com>, tglx@linutronix.de, mingo@redhat.com,
        akpm@linux-foundation.org, arnd@arndb.de, plagnioj@jcrosoft.com,
        tomi.valkeinen@ti.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, stefan.bader@canonical.com,
        luto@amacapital.net, airlied@gmail.com, bp@alien8.de
Subject: Re: [RFC PATCH 0/11] Support Write-Through mapping on x86
References: <1405452884-25688-1-git-send-email-toshi.kani@hp.com> <53C58A69.3070207@zytor.com> <1405459404.28702.17.camel@misato.fc.hp.com> <03d059f5-b564-4530-9184-f91ca9d5c016@email.android.com> <1405546127.28702.85.camel@misato.fc.hp.com> <1405960298.30151.10.camel@misato.fc.hp.com> <53CD443A.6050804@zytor.com> <1405962993.30151.35.camel@misato.fc.hp.com> <53CD4EB2.5020709@zytor.com> <20140721183331.GB13420@laptop.dumpdata.com>
In-Reply-To: <20140721183331.GB13420@laptop.dumpdata.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/21/2014 11:33 AM, Konrad Rzeszutek Wilk wrote:
>>
>> First of all, paravirt functions are the root of all evil, and we want
> 
> Here I was thinking to actually put an entry in the MAINTAINERS
> file for me to become the owner of it - as the folks listed there
> are busy with other things.
> 
> The Maintainer of 'All Evil' has an interesting ring to it :-)
> 

Then you can legitimately title yourself Lord of All Evil.  :)

	-hpa

