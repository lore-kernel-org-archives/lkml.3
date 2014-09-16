Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754432AbaIPNyk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 09:54:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11433 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754402AbaIPNyi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 09:54:38 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Boaz Harrosh <boaz@plexistor.com>
Cc: Dan Williams <dan.j.williams@intel.com>, Boaz Harrosh <openosd@gmail.com>,
        Ross Zwisler <ross.zwisler@linux.intel.com>,
        Jens Axboe <axboe@kernel.dk>,
        Matthew Wilcox <matthew.r.wilcox@intel.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-nvdimm@ml01.01.org
Subject: Re: [Linux-nvdimm] [PATCH v2] pmem: Initial version of persistent memory driver
References: <1409173922-7484-1-git-send-email-ross.zwisler@linux.intel.com>
	<1409173922-7484-2-git-send-email-ross.zwisler@linux.intel.com>
	<540F2977.7010006@plexistor.com>
	<CAPcyv4gZBdtup+DuaYL2zOhP9KcRzDAq6vLih0tbpL+abGQv-g@mail.gmail.com>
	<541050E5.60502@gmail.com>
	<CAPcyv4hfNX4Q75AERfF4g5MVvG82j3tXWcunWiGpBgDS2+7_1Q@mail.gmail.com>
	<54108ECA.6090200@plexistor.com>
	<CAPcyv4gqyiTaSJY56ZrJh05kwh9O9sXNKOz40fGu5s_=eY=U6Q@mail.gmail.com>
	<54117D3A.3010305@plexistor.com>
	<CAPcyv4io2P1TiXdnhQJMiWsYE5Rz+BiiAHqKZhDe5gh88PEWUA@mail.gmail.com>
	<5415797A.7000700@plexistor.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Tue, 16 Sep 2014 09:54:30 -0400
In-Reply-To: <5415797A.7000700@plexistor.com> (Boaz Harrosh's message of "Sun,
	14 Sep 2014 14:18:18 +0300")
Message-ID: <x497g133c2x.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Boaz Harrosh <boaz@plexistor.com> writes:

> On 09/11/2014 07:31 PM, Dan Williams wrote:
> <>
>> 
>> The point I am getting at is not requiring a priori knowledge of the
>> physical memory map of a system.  Rather, place holder variables to
>> enable simple dynamic discovery.
>> 
>
> "simple dynamic discovery" does not yet exist and when the DDR4 NvDIMM
> will be released then we still have those DDR3 out there which will
> not work with the new discovery, which I need to support as well.

Boaz,

Are you telling me that vendors are shipping parts that present
themselves as E820_RAM, and that you have to manually block off the
addresses from the kernel using the kernel command line?  If that is
true, then that is just insane and unsupportable.  All the hardware I
have access to:
1) does not present itself as normal memory and
2) provides some means for discovering its address and size

Cheers,
Jeff
