Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934314AbaJ2P53 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 11:57:29 -0400
Received: from distopic.net ([80.67.6.140]:34038 "EHLO distopic.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932994AbaJ2P52 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 11:57:28 -0400
Message-ID: <54510E1F.3050801@distopic.net>
Date: Wed, 29 Oct 2014 16:56:15 +0100
From: Mikael Svantesson <mikael@distopic.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Jason Cooper <jason@lakedaemon.net>, Jake Edge <jake@lwn.net>,
        Anton Saraev <antonysaraev@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        "mikael@distopic.net >> Mikael Svantesson" <mikael@distopic.net>
Subject: Re: [PATCH v2] staging: skein: skein_api.c: removed space before
 ','
References: <544FF764.7090003@distopic.net> <20141029084118.GB5333@kroah.com>
In-Reply-To: <20141029084118.GB5333@kroah.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-10-29 09:41, Greg Kroah-Hartman wrote:
> On Tue, Oct 28, 2014 at 09:07:00PM +0100, Mikael Svantesson wrote:
>> Signed-off-by: Mikael Svantesson <mikael@distopic.net>
>> ---
>>  drivers/staging/skein/skein_api.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/staging/skein/skein_api.c b/drivers/staging/skein/skein_api.c
>> index 6e700ee..5bfce07 100644
>> --- a/drivers/staging/skein/skein_api.c
>> +++ b/drivers/staging/skein/skein_api.c
>> @@ -31,7 +31,7 @@ int skein_ctx_prepare(struct skein_ctx *ctx, enum skein_size size)
>>  {
>>  	skein_assert_ret(ctx && size, SKEIN_FAIL);
>>  -	memset(ctx , 0, sizeof(struct skein_ctx));
>> +	memset(ctx, 0, sizeof(struct skein_ctx));
> 
> Still corrupted, what added the extra ' ' before the '-'?
> 
Thunderbird builtin editor, I guess. Can't remember why I decided to do
it that way instead of git-send-email.

I replied to my other explanation with a non-corrupt patch but I can
submit it as v3 instead if that's preferable.

/ Mikael
