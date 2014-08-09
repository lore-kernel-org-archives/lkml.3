Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751759AbaHIPEZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2014 11:04:25 -0400
Received: from mail.active-venture.com ([67.228.131.205]:57114 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751125AbaHIPEW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2014 11:04:22 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <53E63871.5040504@roeck-us.net>
Date: Sat, 09 Aug 2014 08:04:17 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, satoru.takeuchi@gmail.com,
        shuah.kh@samsung.com, stable@vger.kernel.org
Subject: Re: [PATCH 3.16 00/17] 3.16.1-stable review
References: <20140808213457.511493898@linuxfoundation.org> <53E57279.1030106@roeck-us.net> <20140809034911.GA2348@kroah.com> <20140809034950.GB2348@kroah.com> <53E5A0D1.10507@roeck-us.net> <20140809141609.GA21639@kroah.com>
In-Reply-To: <20140809141609.GA21639@kroah.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/09/2014 07:16 AM, Greg Kroah-Hartman wrote:
[ .. ]
>> Just for reference, in mainline, we currently have
>> 	total: 133 pass: 127 fail: 6
>> plus four (!) qemu tests failing (arm, mips, mips64, and ppc),
>> meaning there will be three more dropped configurations (all arm
>> as far as I can see), and there is already a bunch of failures.
>> This is with v3.16-9794-g8065be8. next-20140808 build result is
>> 	total: 133 pass: 121 fail: 12
>> with the same failed qemu tests, so it will only get worse :-(.
>>
>> Some improved quality assurance may be helpful going forward,
>> especially since many of the failures seem to be due to lack of
>> (build) testing and could easily have been avoided. Something
>> to discuss in Chicago, maybe.
>
> I wonder if it is just due to the merge not being finished yet?  The
> 0-day built-bot should have caught any major build issues before now
> with the individual trees, so there shouldn't be any reason you should
> be seeing failures :(
>

There are two arm build failures in Linus' tree which are not seen
in -next. Those are either merge problems, or maybe there is some
other series of arm patches coming. Either case, the arm folks are
pretty good at tracking failures, so I assume those will be fixed
soon (especially since multi_v7_defconfig is one of the failing
builds). The other build failures are all seen in -next as well,
so they _should_ be known.

For the qemu failures, they are all the same in -next and in the
tip of Linus' tree, so I guess no one tested the configurations
I use for qemu tests. I only recently added -next to the list of
branches to test, so I only noticed the failures after they showed up
in Linus' tree.

Guenter

