Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933420AbaLDXiF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 18:38:05 -0500
Received: from cantor2.suse.de ([195.135.220.15]:34908 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754811AbaLDXiD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 18:38:03 -0500
Message-ID: <5480F057.9010203@suse.de>
Date: Fri, 05 Dec 2014 00:37:59 +0100
From: Alexander Graf <agraf@suse.de>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.10; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Will Deacon <will.deacon@arm.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>, Michael Matz <matz@suse.de>
Subject: Re: [PATCH] arm64: Enable CONFIG_COMPAT also for 64k page size
References: <1417707993-82290-1-git-send-email-agraf@suse.de> <20141204182049.GB7749@arm.com>
In-Reply-To: <20141204182049.GB7749@arm.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 04.12.14 19:20, Will Deacon wrote:
> On Thu, Dec 04, 2014 at 03:46:33PM +0000, Alexander Graf wrote:
>> With binutils 2.25 the default alignment for 32bit arm sections changed to
>> have everything 64k aligned. Armv7 binaries built with this binutils version
>> run successfully on an arm64 system.
>>
>> Since effectively there is now the chance to run armv7 code on arm64 even
>> with 64k page size, it doesn't make sense to block people from enabling
>> CONFIG_COMPAT on those configurations.
> 
> Is there a distro available that is built with a recent enough binutils for
> this? I'd really like to run our regression tests to check that page-size
> assumptions don't exist for things like shm.

I don't have a full distribution for you yet, but we'll start to switch
to the 2.25 branch soon.

Michael, what are you plans on when a first armv7 Factory build based on
2.25 would be available?


Alex
