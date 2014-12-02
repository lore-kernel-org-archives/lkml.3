Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753517AbaLBOA1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 09:00:27 -0500
Received: from mx1.redhat.com ([209.132.183.28]:46546 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751065AbaLBOAX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 09:00:23 -0500
Date: Tue, 2 Dec 2014 09:00:17 -0500
From: Mike Snitzer <snitzer@redhat.com>
To: zhangxiao <xiao.zhang@windriver.com>
Cc: agk@redhat.com, linux-kernel@vger.kernel.org, NeilBrown <neilb@suse.de>,
        linux-raid@vger.kernel.org, dm-devel@redhat.com
Subject: Re: The DM_BUFIO_HASH_BITS is defined as 20, any plan to make it
 flexible?
Message-ID: <20141202140015.GB5985@redhat.com>
References: <547D7BC6.6070708@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <547D7BC6.6070708@windriver.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 02 2014 at  3:43am -0500,
zhangxiao <xiao.zhang@windriver.com> wrote:

> Hi Experts,
> 
> See drivers/md/dm-bufio.c as below:
>   50 /*
>   51  * Buffer hash
>   52  */
>   53 #define DM_BUFIO_HASH_BITS      20
>   54 #define DM_BUFIO_HASH(block) \
>   55         ((((block) >> DM_BUFIO_HASH_BITS) ^ (block)) & \
>   56          ((1 << DM_BUFIO_HASH_BITS) - 1))
> "drivers/md/dm-bufio.c" 1854L, 45375C
> 
> DM_BUFIO_HASH_BITS was defined as 20 and it maybe not fit for some
> use case with limited resources. Do we have any plan to make it more
> flexible? Like module parameter or something else?

No immediate plans.
