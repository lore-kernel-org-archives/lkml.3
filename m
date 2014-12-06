Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752156AbaLFRYF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2014 12:24:05 -0500
Received: from cantor2.suse.de ([195.135.220.15]:32933 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751244AbaLFRYD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2014 12:24:03 -0500
Message-ID: <54833BAF.1030405@suse.de>
Date: Sat, 06 Dec 2014 18:23:59 +0100
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

So how much of a distro do you need? I could probably assemble a simple
very minimalistic rootfs with only bash if that helps.


Alex
