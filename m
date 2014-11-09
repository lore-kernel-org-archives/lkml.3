Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751720AbaKISvy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2014 13:51:54 -0500
Received: from mxf1.bahnhof.se ([213.80.101.25]:61047 "EHLO mxf1.bahnhof.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751059AbaKISvx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2014 13:51:53 -0500
X-Spam-Score: 0
Message-ID: <545FB7B8.5080506@flawful.org>
Date: Sun, 09 Nov 2014 19:51:36 +0100
From: Niklas Svensson <nks@flawful.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Jason Cooper <jason@lakedaemon.net>
CC: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        eric.rost@mybabylon.net, gregkh@linuxfoundation.org
Subject: Re: [PATCH] staging: skein: fixed sparse warnings related to static
 declarations
References: <1415461758-9587-1-git-send-email-nks@flawful.org> <20141108195633.GM3698@titan.lakedaemon.net>
In-Reply-To: <20141108195633.GM3698@titan.lakedaemon.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 11/08/2014 08:56 PM, Jason Cooper wrote:
> On Sat, Nov 08, 2014 at 04:49:18PM +0100, Niklas Svensson wrote:
>> drivers/staging/skein/skein_generic.c:30:5: warning: symbol 'skein256_update' was not declared. Should it be static?
>> drivers/staging/skein/skein_generic.c:65:5: warning: symbol 'skein512_update' was not declared. Should it be static?
>> drivers/staging/skein/skein_generic.c:100:5: warning: symbol 'skein1024_update' was not declared. Should it be static?
>>
>> Signed-off-by: Niklas Svensson <nks@flawful.org>
>> ---
>>  drivers/staging/skein/skein_generic.c | 6 +++---
>>  1 file changed, 3 insertions(+), 3 deletions(-)
> What tree/tag is this patch against?  There've been quite a few changes
> to the api this time around.
linux-next,
tag: next-20141106

also applicable for gregkg's staging-next tree
