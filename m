Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753818AbbALQR0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 11:17:26 -0500
Received: from a.ns.miles-group.at ([95.130.255.143]:65275 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753086AbbALQRZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 11:17:25 -0500
Message-ID: <54B3F392.7010601@nod.at>
Date: Mon, 12 Jan 2015 17:17:22 +0100
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Rob Landley <rob@landley.net>,
        Richard Weinberger <richard.weinberger@gmail.com>,
        Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] out out damn perl
References: <54AC72AF.5090609@landley.net>	<20150112151625.GA30247@csclub.uwaterloo.ca> <CAFLxGvyyujXptcD3d6AF+Fri+UC_G1n8ED+uJZZ0TuD22kszow@mail.gmail.com> <54B3F2E2.5030807@landley.net>
In-Reply-To: <54B3F2E2.5030807@landley.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 12.01.2015 um 17:14 schrieb Rob Landley:
> On 01/12/2015 09:27 AM, Richard Weinberger wrote:
>> On Mon, Jan 12, 2015 at 4:16 PM, Lennart Sorensen
>> <lsorense@csclub.uwaterloo.ca> wrote:
>>> On Tue, Jan 06, 2015 at 05:41:35PM -0600, Rob Landley wrote:
>>>> From: Rob Landley <rob@landley.net>
>>>>
>>>> Commit e6023367d779 added perl back to the kernel build in -rc6.
>>>> Replace 39 lines of perl with 4 lines of shell script.
>>>
>>> Maybe checkpatch should be updated to look for perl. :)
>>
>> Yeah, then checkpatch.pl warn on itself. ;-)
> 
> There's a difference between a development tool and a build tool. We
> have "make xconfig" and "make gconfig" but don't require qt and gtk to
> both be in your cross compile environment in order to build the kernel.

You got me wrong. I'm all for removing perl as build dependency.

Thanks,
//richard
