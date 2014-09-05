Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932812AbaIEOad (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 10:30:33 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:65242 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751379AbaIEOac (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 10:30:32 -0400
Message-ID: <5409C906.20503@kernel.dk>
Date: Fri, 05 Sep 2014 08:30:30 -0600
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Vasiliy Tolstov <v.tolstov@selfip.ru>
CC: Francis Moreau <francis.moro@gmail.com>,
        Kent Overstreet <kmo@daterainc.com>, Peter Kieser <peter@kieser.ca>,
        linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org,
        stable <stable@vger.kernel.org>
Subject: Re: [GIT PULL] bcache changes for 3.17
References: <20140805043346.GF541@moria.home.lan> <53E10D48.1010700@kernel.dk> <53E7251B.3080305@kieser.ca> <540966BA.9030106@gmail.com> <5409C5FC.6020406@kernel.dk> <CACaajQvnELSGtudtPXv1ELosk0JT4GjcqUWXtjJ_r4Hb-8ebKw@mail.gmail.com>
In-Reply-To: <CACaajQvnELSGtudtPXv1ELosk0JT4GjcqUWXtjJ_r4Hb-8ebKw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/05/2014 08:28 AM, Vasiliy Tolstov wrote:
> 2014-09-05 18:17 GMT+04:00 Jens Axboe <axboe@kernel.dk>:
>>
>> We need to do something about this. From this latest pull, looks like
>> all should go to stable:
>>
>> 5b1016e62f74c53e0330403025954c8d95384c03
>> 9aa61a992acceeec0d1de2cd99938421498659d5
>> dbd810ab678d262d3772d29b65844d7b20dc47bc
>> 8b326d3a2a76912dfed2f0ab937d59fae9512ca2
>> e5112201c1285841f8b565ece5d6ae7e0d7947a2
>> a664d0f05a2ec02c8f042db536d84d15d6e19e81
>> c5aa4a3157b55bdca18dd2a9d9f43314470b6d32
>> 9e5c353510b26500bd6b8309823ac9ef2837b761
>> bcf090e0040e30f8409e6a535a01e6473afb096f
>> 501d52a90cbe652b41336c206ff0e95799d5a9b5
>> 8e0948080670f6330229718b15a6a1a011d441ce
>> 60ae81eee86dd7a520db8c1e3d702b49fc0418b5
>> 913dc33fb2720fb5f979011664294137ddd8b13b
>> 6b708de64adb6dc8319e7aeac922b46904fbeeec
>> 400ffaa2acd72274e2c7293a9724382383bebf3e
>> d83353b319d47ef8cce82467da6a25c2d558253f
>> bf0c55c986540483c34ca640f2eef4c3314388b1
>> c9a78332b42cbdcdd386a95192a716b67d1711a4
>> 2452cc89063a2a6890368f185c4b6d7d8802175b
>> 25abade29616d42d60f9bd5e6a5ad07f7314e39e
>> 5b25abade29616d42d60f9bd5e6a5ad07f7314e3
>> 789d21dbd9d8889e62c79ec19585fcc97e42ef07
>> 0781c8748cf1ea2b0dcd966571103909528c4efa
>>
>> (from oldest to newest). And that's just from 3.16 to 3.17-rc3, going
>> all the way back to 3.10 would be a lot of work. If there's anyone that
>> cares about bcache on stable kernels (and actually use it), now would be
>> a good time to pipe up.
> 
> 
> I'm interesting on backporting this to 3.14.y

Before that can happen, you would probably need to comb the 3.15 and
3.16 bcache inclusions and dig out any potential stable candidates there
too.


-- 
Jens Axboe

