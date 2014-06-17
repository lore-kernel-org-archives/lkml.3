Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756177AbaFQSjK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 14:39:10 -0400
Received: from mail-pb0-f52.google.com ([209.85.160.52]:46967 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754403AbaFQSjI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 14:39:08 -0400
Message-ID: <53A08B47.3010701@gmail.com>
Date: Tue, 17 Jun 2014 21:39:03 +0300
From: Boaz Harrosh <openosd@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Matthew Wilcox <willy@linux.intel.com>
CC: Matthew Wilcox <matthew.r.wilcox@intel.com>, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 00/22] Support ext4 on NV-DIMMs
References: <cover.1395591795.git.matthew.r.wilcox@intel.com> <53A084E3.6080103@gmail.com> <20140617181925.GF12025@linux.intel.com>
In-Reply-To: <20140617181925.GF12025@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/17/2014 09:19 PM, Matthew Wilcox wrote:
> On Tue, Jun 17, 2014 at 09:11:47PM +0300, Boaz Harrosh wrote:
> 
> https://github.com/01org/prd should sort you out with both a git tree
> and a new block driver.  You'll need to tell it manually what address
> range to use.  I'm using it against regular DIMMs, and this works pretty
> well for me since my BIOS doesn't zero DRAM on reset.
> 

God Yes exactly my missing link, Thanks. How I failed to find it?

Yes for us too, BIOS doesn't zero DRAM and we can use it with using
memmap= on kernel boot.

Please include above link in new patchset and Documentation. Just
to make the overall picture clearer. BTW what prevents from submitting
this prd driver upstream right now? there are devices out there that will
need it no? Even for something simple and very smart as putting my
ext4 or xfs journal device on nv-dimm, no?
The "manually address range to use" is fine in my book. A user-mode
udev rule can then be used to cover the gap from sbus or acpi to prd.

Hey actually this tree has everything I need. thanks man
Boaz

