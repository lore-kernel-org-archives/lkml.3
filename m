Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751020AbaIUJ1g (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2014 05:27:36 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:64873 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750707AbaIUJ1e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2014 05:27:34 -0400
Message-ID: <541E99FF.9050607@plexistor.com>
Date: Sun, 21 Sep 2014 12:27:27 +0300
From: Boaz Harrosh <boaz@plexistor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Dan Williams <dan.j.williams@intel.com>, Jeff Moyer <jmoyer@redhat.com>
CC: Boaz Harrosh <openosd@gmail.com>,
        Ross Zwisler <ross.zwisler@linux.intel.com>,
        Jens Axboe <axboe@kernel.dk>,
        Matthew Wilcox <matthew.r.wilcox@intel.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-nvdimm@ml01.01.org
Subject: Re: [Linux-nvdimm] [PATCH v2] pmem: Initial version of persistent
 memory driver
References: <1409173922-7484-1-git-send-email-ross.zwisler@linux.intel.com>	<1409173922-7484-2-git-send-email-ross.zwisler@linux.intel.com>	<540F2977.7010006@plexistor.com>	<CAPcyv4gZBdtup+DuaYL2zOhP9KcRzDAq6vLih0tbpL+abGQv-g@mail.gmail.com>	<541050E5.60502@gmail.com>	<CAPcyv4hfNX4Q75AERfF4g5MVvG82j3tXWcunWiGpBgDS2+7_1Q@mail.gmail.com>	<54108ECA.6090200@plexistor.com>	<CAPcyv4gqyiTaSJY56ZrJh05kwh9O9sXNKOz40fGu5s_=eY=U6Q@mail.gmail.com>	<54117D3A.3010305@plexistor.com>	<CAPcyv4io2P1TiXdnhQJMiWsYE5Rz+BiiAHqKZhDe5gh88PEWUA@mail.gmail.com>	<5415797A.7000700@plexistor.com>	<x497g133c2x.fsf@segfault.boston.devel.redhat.com> <CAPcyv4hb_qpJbCg6n0m0d87=Gi10kw3P3Rx6tHCOTNYffHa_fw@mail.gmail.com>
In-Reply-To: <CAPcyv4hb_qpJbCg6n0m0d87=Gi10kw3P3Rx6tHCOTNYffHa_fw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/19/2014 07:27 PM, Dan Williams wrote:
> before adding any new device
> discovery capabilities to pmem.
> 

I lost you? what "new device discovery capabilities" do you see in
Ross's or my code to pmem?

Actually my point is that I hope there will never be any. That the discovery
should be elsewhere in an ARCH/driver LLD and pmem stays generic.

I feel we are not disagreeing, just not communicating. Please explain again,
sorry for not understanding. What in the code I sent, you do not like? What
in the code is dependent on UEFI organization's paper. That might need to
change?

Again sorry for being slow. please explain again?

Thanks
Boaz

