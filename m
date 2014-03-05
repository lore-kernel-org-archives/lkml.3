Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756024AbaCEAAm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 19:00:42 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:32971 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755945AbaCEAAk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 19:00:40 -0500
Message-ID: <53166920.709@oracle.com>
Date: Tue, 04 Mar 2014 19:00:32 -0500
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Jan Kara <jack@suse.cz>
CC: Al Viro <viro@ZenIV.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: fs: gpf in simple_setattr
References: <52B23CEA.7090405@oracle.com> <52CD762B.7020600@oracle.com> <53123D81.6080003@oracle.com> <20140303214040.GA15265@quack.suse.cz>
In-Reply-To: <20140303214040.GA15265@quack.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/03/2014 04:40 PM, Jan Kara wrote:
> On Sat 01-03-14 15:05:21, Sasha Levin wrote:
>> >ping again?
>> >
>> >I've been working on it, but don't see an obvious issue.
>> >
>> >It does look like an access to invalid memory easily doable from
>> >userspace, so it should probably get fixed soon...
>    Hum, can you maybe dump the name in dentry passed to simple_setattr()? Or
> maybe even the whole path using dentry_path() (but not sure if that will
> be workable on half-torn-down fs)? Maybe it will give us a hint at which
> filesystem to look...

It's just garbage, this is why I'm having a hard time making any progress with
this bug.


Thanks,
Sasha
