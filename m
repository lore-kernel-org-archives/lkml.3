Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753326AbaCJOOA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 10:14:00 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:34180 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752258AbaCJON6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 10:13:58 -0400
Message-ID: <531DC89A.9010601@oracle.com>
Date: Mon, 10 Mar 2014 10:13:46 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Jan Kara <jack@suse.cz>
CC: Al Viro <viro@ZenIV.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: fs: gpf in simple_setattr
References: <52B23CEA.7090405@oracle.com> <52CD762B.7020600@oracle.com> <53123D81.6080003@oracle.com> <20140303214040.GA15265@quack.suse.cz> <53166920.709@oracle.com> <20140305124536.GA32371@quack.suse.cz> <53189BF8.1010308@oracle.com> <531A7CFD.9030603@oracle.com> <20140310104350.GB28797@quack.suse.cz>
In-Reply-To: <20140310104350.GB28797@quack.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/10/2014 06:43 AM, Jan Kara wrote:
>    By garbage, do you mean that it is a poison, completely random data or does
> inode->i_sb look like a valid pointer but just superblock isn't where it
> points to?

It's poison.

>> >Any way I could get anything useful any other way?
>    Hum, can you dump the whole contents of 'dentry' at that place? Maybe it
> will tell us something.

I'll give it a go, will update when it happens again.


Thanks,
Sasha
