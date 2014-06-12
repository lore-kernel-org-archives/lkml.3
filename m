Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755211AbaFLApD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 20:45:03 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54646 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754678AbaFLApB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 20:45:01 -0400
Message-ID: <5398F7F9.9000106@zytor.com>
Date: Wed, 11 Jun 2014 17:44:41 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@linux.intel.com>, "Theodore Ts'o" <tytso@mit.edu>,
        George Spelvin <linux@horizon.com>, linux-kernel@vger.kernel.org,
        mingo@kernel.org, price@mit.edu
Subject: Re: drivers/char/random.c: More futzing about
References: <20140609013553.GA1167@thunk.org> <20140609131738.13625.qmail@ns.horizon.com> <20140611163818.GD27151@thunk.org> <5398885F.10206@linux.intel.com> <20140611192557.GE27151@thunk.org> <5398BF08.5070005@linux.intel.com>
In-Reply-To: <5398BF08.5070005@linux.intel.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/11/2014 01:41 PM, H. Peter Anvin wrote:
> On 06/11/2014 12:25 PM, Theodore Ts'o wrote:
>> On Wed, Jun 11, 2014 at 09:48:31AM -0700, H. Peter Anvin wrote:
>>> While talking about performance, I did a quick prototype of random using
>>> Skein instead of SHA-1, and it was measurably faster, in part because
>>> Skein produces more output per hash.
>>
>> Which Skein parameters did you use, and how much stack space was
>> required for it?  Skein-512 is described as needing 200 bytes of
>> state, IIRC (which I assume most of which comes from Threefish key
>> schedule). 
>>
> 
> I believe I used Skein-256, but I'd have to dig to find it again.
> 
> 	-hpa
> 

Sadly I can't find the tree, but I'm 94% sure it was Skein-256
(specifically the SHA3-256 candidate parameter set.)

	-hpa


