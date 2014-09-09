Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752968AbaIIWoB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 18:44:01 -0400
Received: from mail-la0-f42.google.com ([209.85.215.42]:39066 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752906AbaIIWn6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 18:43:58 -0400
MIME-Version: 1.0
In-Reply-To: <20140908212514.GA2348@awork2.anarazel.de>
References: <20140907.164109.1944849896872238507.davem@davemloft.net>
	<20140908212514.GA2348@awork2.anarazel.de>
Date: Tue, 9 Sep 2014 15:43:55 -0700
Message-ID: <CAHA+R7NCwhMaWX0Mhr7AqHH4x5RZ6TEEiJB7906yVzQouXD3Lg@mail.gmail.com>
Subject: Re: Macvlan WARNiNGS about duplicate sysfs filenames (Was [GIT] Networking)
From: Cong Wang <cwang@twopensource.com>
To: Andres Freund <andres@anarazel.de>,
        "Alexander Y. Fomichev" <git.user@gmail.com>
Cc: David Miller <davem@davemloft.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        netdev <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 8, 2014 at 2:25 PM, Andres Freund <andres@anarazel.de> wrote:
> Hi,
>
> (don't have netdev archived, thus answering here, sorry)
>
> On 2014-09-07 16:41:09 -0700, David Miller wrote:
>> Alexander Y. Fomichev (1):
>>       net: prevent of emerging cross-namespace symlinks
>

Since you are quoting this change, are you saying it causes
the following kernel warning?


> I'm seeing WARNINGs like:
> [ 1005.269134] ------------[ cut here ]------------
> [ 1005.269148] WARNING: CPU: 6 PID: 4213 at fs/sysfs/dir.c:31 sysfs_warn_dup+0x64/0x80()
> [ 1005.269150] sysfs: cannot create duplicate filename '/devices/pci0000:00/0000:00:1c.4/0000:03:00.0/net/eth0/upper_mv-eth0'


Is there a network device named upper_mv-eth0 existed in your system
before you created macvlan?
