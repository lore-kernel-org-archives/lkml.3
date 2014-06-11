Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754029AbaFKUlr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 16:41:47 -0400
Received: from mga01.intel.com ([192.55.52.88]:3520 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751220AbaFKUlq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 16:41:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,460,1400050800"; 
   d="scan'208";a="554016795"
Message-ID: <5398BF08.5070005@linux.intel.com>
Date: Wed, 11 Jun 2014 13:41:44 -0700
From: "H. Peter Anvin" <hpa@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: "Theodore Ts'o" <tytso@mit.edu>, George Spelvin <linux@horizon.com>,
        linux-kernel@vger.kernel.org, mingo@kernel.org, price@mit.edu
Subject: Re: drivers/char/random.c: More futzing about
References: <20140609013553.GA1167@thunk.org> <20140609131738.13625.qmail@ns.horizon.com> <20140611163818.GD27151@thunk.org> <5398885F.10206@linux.intel.com> <20140611192557.GE27151@thunk.org>
In-Reply-To: <20140611192557.GE27151@thunk.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/11/2014 12:25 PM, Theodore Ts'o wrote:
> On Wed, Jun 11, 2014 at 09:48:31AM -0700, H. Peter Anvin wrote:
>> While talking about performance, I did a quick prototype of random using
>> Skein instead of SHA-1, and it was measurably faster, in part because
>> Skein produces more output per hash.
> 
> Which Skein parameters did you use, and how much stack space was
> required for it?  Skein-512 is described as needing 200 bytes of
> state, IIRC (which I assume most of which comes from Threefish key
> schedule). 
> 

I believe I used Skein-256, but I'd have to dig to find it again.

	-hpa


