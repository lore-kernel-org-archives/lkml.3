Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756197AbaIEH2p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 03:28:45 -0400
Received: from mail-lb0-f182.google.com ([209.85.217.182]:59304 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753636AbaIEH2n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 03:28:43 -0400
Message-ID: <540966BA.9030106@gmail.com>
Date: Fri, 05 Sep 2014 09:31:06 +0200
From: Francis Moreau <francis.moro@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>, Kent Overstreet <kmo@daterainc.com>
CC: Peter Kieser <peter@kieser.ca>, linux-kernel@vger.kernel.org,
        linux-bcache@vger.kernel.org, stable <stable@vger.kernel.org>
Subject: Re: [GIT PULL] bcache changes for 3.17
References: <20140805043346.GF541@moria.home.lan> <53E10D48.1010700@kernel.dk> <53E7251B.3080305@kieser.ca>
In-Reply-To: <53E7251B.3080305@kieser.ca>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/10/2014 09:54 AM, Peter Kieser wrote:
> 
> On 2014-08-05 9:58 AM, Jens Axboe wrote:
>> On 08/04/2014 10:33 PM, Kent Overstreet wrote:
>>> Hey Jens, here's the pull request for 3.17 - typically late, but lots of tasty
>>> fixes in this one :)
>> Normally I'd say no, but since it's basically just fixes, I guess we can
>> pull it in. But generally, it has to be in my hands a week before this,
>> so it can simmer a bit in for-next before going in...
>>
> Are these fixes going to be backported to 3.10 or other stable releases?
> 

Could you please answer this question ?

If you don't want to maintain bcache for stable kernels (I can
understand that), can you mark it at least as unstable/experimental
stuff since it really is ?

Thanks

