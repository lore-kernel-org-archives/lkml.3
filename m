Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752914AbbALJa2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 04:30:28 -0500
Received: from mail-we0-f173.google.com ([74.125.82.173]:39764 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752331AbbALJaW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 04:30:22 -0500
Message-ID: <54B3942D.2080006@profitbricks.com>
Date: Mon, 12 Jan 2015 10:30:21 +0100
From: Sebastian Parschauer <sebastian.riemer@profitbricks.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Fam Zheng <famz@redhat.com>
CC: Jens Axboe <axboe@kernel.dk>,
        Eduardo Otubo <eduardo.otubo@profitbricks.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        virtualization@lists.linux-foundation.org
Subject: Re: blk-mq v3.18: Oops during virtio_blk hot-unplug
References: <54AFE664.6010002@profitbricks.com> <20150110012036.GC8570@fam-t430.nay.redhat.com>
In-Reply-To: <20150110012036.GC8570@fam-t430.nay.redhat.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10.01.2015 02:20, Fam Zheng wrote:
> On Fri, 01/09 15:32, Sebastian Parschauer wrote:
>> Hi Jens,
>>
>> my colleague Eduardo is sporadically seeing an Oops in blk-mq while
>> running continuous virtio_blk hot-plug/hot-unplug tests with I/O to the
>> device within an x86_64 QEMU/KVM 2.0 Debian Wheezy VM.
>>
>> Please find the call trace attached and the full log here:
>> http://paste.ubuntu.com/9691873/
>>
>> The kernel image has been taken from here and is the mainline kernel
>> from tag v3.18:
>> http://kernel.ubuntu.com/~kernel-ppa/mainline/v3.18-vivid/
>>
>> Is there still an issue with block queue freezing?
> 
> This one?
> 
> commit 45a9c9d909b24c6ad0e28a7946e7486e73010319
> Author: Bart Van Assche <bvanassche@acm.org>
> Date:   Tue Dec 9 16:57:48 2014 +0100
> 
>     blk-mq: Fix a use-after-free
> 
> Fam

Yes, pretty much looks like it, thanks!

Cheers,
Sebastian

