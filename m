Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755118AbaCNOyg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 10:54:36 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:37049 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754502AbaCNOye (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 10:54:34 -0400
Date: Fri, 14 Mar 2014 10:54:30 -0400
From: Tejun Heo <tj@kernel.org>
To: Jan Kara <jack@suse.cz>
Cc: Roman Peniaev <r.peniaev@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 1/1] fs/mpage.c: forgotten WRITE_SYNC in case of data
 integrity write
Message-ID: <20140314145430.GL12613@htj.dyndns.org>
References: <CACZ9PQV8RsaefFAOt5b-aL33G3CiD+3+fTuW15io6u1DH3XJ6Q@mail.gmail.com>
 <CACZ9PQUKzsP4mwJSO3c=Z3W2pYr2AME-9j+1Cqg9t8a4T+uQQg@mail.gmail.com>
 <20140313200119.GB504@quack.suse.cz>
 <20140313143456.157404fd7f208638ca70e317@linux-foundation.org>
 <20140314130712.GC12613@htj.dyndns.org>
 <CACZ9PQUQX-sSNo+z0LB0Tefq9pSHFr6GjKg2tWzdAtw3OYYDsg@mail.gmail.com>
 <20140314141143.GH12613@htj.dyndns.org>
 <20140314141511.GF18583@quack.suse.cz>
 <CACZ9PQXNK=z-bk8BJ8rmU9dJiEAcoHBFBoGDK_QoJ0NQFweufQ@mail.gmail.com>
 <20140314145215.GG18583@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140314145215.GG18583@quack.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 14, 2014 at 03:52:15PM +0100, Jan Kara wrote:
>   Well, for ext2, you can use ext4 kernel driver which takes care of
> REQ_FLUSH properly. For fat, you'll need to fix the fs...

This is a bit surprising tho.  Were we always like this?  We never had
even stupid "flush down everything and sync"?  Or is this something we
broke while morphing flush implementation several times in the past
years?

Thanks.

-- 
tejun
