Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754269AbaIPXis (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 19:38:48 -0400
Received: from casper.infradead.org ([85.118.1.10]:55629 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753982AbaIPXip (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 19:38:45 -0400
Message-ID: <5418C9FD.1090400@infradead.org>
Date: Tue, 16 Sep 2014 16:38:37 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Peter Foley <pefoley2@pefoley.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: build failure after merge of the rd-docs tree
References: <20140916171102.61509be5@canb.auug.org.au> <CAOFdcFMDnR50cS-Geb0S1S2VRPzZqDr9zzqUp-DpMYLfF0qtvQ@mail.gmail.com> <20140917090020.1f3c2c30@canb.auug.org.au> <CAOFdcFOXQRmxFQV_ei3xcdRLaCxEa4yjc=s=xjNM6R3SQBySgg@mail.gmail.com>
In-Reply-To: <CAOFdcFOXQRmxFQV_ei3xcdRLaCxEa4yjc=s=xjNM6R3SQBySgg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/16/14 16:18, Peter Foley wrote:
> On Tue, Sep 16, 2014 at 7:00 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>> Hi Peter,
>>
>> My build machine runs Debian stable which only has libc6 version 2.13.
> 
> Ok, depending on a specific glibc version seems kinda hacky.
> Maybe we should just disable auto-building vdso_test?
> 
> Randy?
> --

I don't have a good answer to that, so yes, I suppose just
disable it.  Please send a patch.

Thanks,
-- 
~Randy
