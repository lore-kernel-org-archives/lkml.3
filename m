Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756252Ab3HLMmm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 08:42:42 -0400
Received: from mail2.gnudd.com ([213.203.150.91]:46421 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754714Ab3HLMml (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 08:42:41 -0400
Date: Mon, 12 Aug 2013 14:42:27 +0200
From: Alessandro Rubini <rubini@gnudd.com>
To: wangyun@linux.vnet.ibm.com
Cc: fengguang.wu@intel.com, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [fmc] BUG: scheduling while atomic: swapper/0/1/0x00000002
Message-ID: <20130812124227.GA22310@mail.gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: GnuDD, Device Drivers, Embedded Systems, Courses
In-Reply-To: <52088127.7070109@linux.vnet.ibm.com>
References: <52088127.7070109@linux.vnet.ibm.com>
  <20130811135232.GA16878@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On 08/11/2013 09:52 PM, Fengguang Wu wrote:
>> FYI, the bug still exists in the upstream and linux-next kernels.

Strange. Greg approved the patch I sent. I see it in next-20130809
but also next-20130801 and other ones with the same hash:

   783c2fb FMC: fix locking in sample chardev driver

However, it is not in master.

It was sent as https://lkml.org/lkml/2013/7/16/196 .

Greg, can you please put the patch in the bugfix queue?

Thanks
/alessandro
