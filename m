Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755096AbaLHKrF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 05:47:05 -0500
Received: from cantor2.suse.de ([195.135.220.15]:53364 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752864AbaLHKrD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 05:47:03 -0500
Message-ID: <548581A4.1010206@suse.de>
Date: Mon, 08 Dec 2014 11:47:00 +0100
From: Alexander Graf <agraf@suse.de>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.10; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Will Deacon <will.deacon@arm.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>, Michael Matz <matz@suse.de>
Subject: Re: [PATCH] arm64: Enable CONFIG_COMPAT also for 64k page size
References: <1417707993-82290-1-git-send-email-agraf@suse.de> <20141204182049.GB7749@arm.com> <54833BAF.1030405@suse.de> <20141208101026.GD27367@arm.com>
In-Reply-To: <20141208101026.GD27367@arm.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 08.12.14 11:10, Will Deacon wrote:
> On Sat, Dec 06, 2014 at 05:23:59PM +0000, Alexander Graf wrote:
>> On 04.12.14 19:20, Will Deacon wrote:
>>> On Thu, Dec 04, 2014 at 03:46:33PM +0000, Alexander Graf wrote:
>>>> With binutils 2.25 the default alignment for 32bit arm sections changed to
>>>> have everything 64k aligned. Armv7 binaries built with this binutils version
>>>> run successfully on an arm64 system.
>>>>
>>>> Since effectively there is now the chance to run armv7 code on arm64 even
>>>> with 64k page size, it doesn't make sense to block people from enabling
>>>> CONFIG_COMPAT on those configurations.
>>>
>>> Is there a distro available that is built with a recent enough binutils for
>>> this? I'd really like to run our regression tests to check that page-size
>>> assumptions don't exist for things like shm.
>>
>> So how much of a distro do you need? I could probably assemble a simple
>> very minimalistic rootfs with only bash if that helps.
> 
> I'd like to run LTP, so I'd probably need slightly more than that but I
> certainly don't need the whole world.

Let me check with a few folks what we can easily assemble :).


Alex
