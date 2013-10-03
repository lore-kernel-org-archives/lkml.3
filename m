Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754182Ab3JCOfk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 10:35:40 -0400
Received: from g4t0016.houston.hp.com ([15.201.24.19]:2234 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753397Ab3JCOfj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 10:35:39 -0400
Message-ID: <524D2B77.7090006@hp.com>
Date: Thu, 03 Oct 2013 02:31:51 -0600
From: Thavatchai Makphaibulchoke <thavatchai.makpahibulchoke@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: T Makphaibulchoke <tmac@hp.com>, tytso@mit.edu, adilger.kernel@dilger.ca,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, aswin@hp.com,
        aswin_proj@lists.hp.com
Subject: Re: [PATCH 2/2] fs/ext4/namei.c: reducing contention on s_orphan_lock
 mmutex
References: <1380728219-60784-1-git-send-email-tmac@hp.com> <1380728219-60784-2-git-send-email-tmac@hp.com> <20131003020526.GA22501@gmail.com>
In-Reply-To: <20131003020526.GA22501@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/02/2013 08:05 PM, Zheng Liu wrote:
> Hello,
> 

>> -	if (!EXT4_SB(sb)->s_journal)
>> +	if (ext4_sb->s_journal)
>         ^^^^^^^^
>         typo: !ext4_sb->s_journal
> I am not sure whether or not this will impact the result because when
> journal is enabled the inode will not be added into orphan list.
> 
> Regards,
>                                                 - Zheng
> 
Thanks Zheng for pointing out the problem.  Will fix the problem and rerun the test.

Thanks,
Mak.


