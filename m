Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932948AbaICPsD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 11:48:03 -0400
Received: from relay.parallels.com ([195.214.232.42]:55215 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932852AbaICPsA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 11:48:00 -0400
Message-ID: <5407382D.1020809@parallels.com>
Date: Wed, 3 Sep 2014 19:47:57 +0400
From: Pavel Emelyanov <xemul@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: "J. Bruce Fields" <bfields@fieldses.org>
CC: Jeff Layton <jlayton@poochiereds.net>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        <linux-api@vger.kernel.org>
Subject: Re: [PATCH] locks: Ability to test for flock presence on fd
References: <5405FBAE.5020303@parallels.com> <20140902184456.GC31793@fieldses.org> <54061562.4080306@parallels.com> <20140902194300.GE31793@fieldses.org> <20140902155351.79183446@tlielax.poochiereds.net> <540727E0.6030005@parallels.com> <20140903154434.GC22731@fieldses.org>
In-Reply-To: <20140903154434.GC22731@fieldses.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [89.169.95.100]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/03/2014 07:44 PM, J. Bruce Fields wrote:
...

>> Hope this explanation is more clear.
> 
> Thanks, I think I understand.
> 
> Remind me how you figure out which file descriptors point to the same
> file description (struct file)?

We do it with the help of kcmp() syscall:
https://github.com/cyrillos/linux-2.6/commit/951bc60c6a

Thanks,
Pavel

