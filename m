Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755013AbaIDScC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 14:32:02 -0400
Received: from lists.s-osg.org ([54.187.51.154]:52912 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753631AbaIDScA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 14:32:00 -0400
Message-ID: <5408B01D.50804@osg.samsung.com>
Date: Thu, 04 Sep 2014 12:31:57 -0600
From: Shuah Khan <shuahkh@osg.samsung.com>
Organization: Samsung Open Source Group
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Pranith Kumar <bobby.prani@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>,
        David Herrmann <dh.herrmann@gmail.com>,
        "open list:KERNEL SELFTEST F..." <linux-api@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuahkh@osg.samsung.com>
Subject: Re: [PATCH Resend] memfd_test: Add missing argument to printf()
References: <1409846302-3513-1-git-send-email-bobby.prani@gmail.com>
In-Reply-To: <1409846302-3513-1-git-send-email-bobby.prani@gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/04/2014 09:58 AM, Pranith Kumar wrote:
> Add a missing path argument buf to printf() 
> 
> Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
> Reviewed-by: David Herrmann <dh.herrmann@gmail.com>
> ---
>  tools/testing/selftests/memfd/memfd_test.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/memfd/memfd_test.c b/tools/testing/selftests/memfd/memfd_test.c
> index 3634c90..c343df8 100644
> --- a/tools/testing/selftests/memfd/memfd_test.c
> +++ b/tools/testing/selftests/memfd/memfd_test.c
> @@ -205,7 +205,7 @@ static void mfd_fail_open(int fd, int flags, mode_t mode)
>  	sprintf(buf, "/proc/self/fd/%d", fd);
>  	r = open(buf, flags, mode);
>  	if (r >= 0) {
> -		printf("open(%s) didn't fail as expected\n");
> +		printf("open(%s) didn't fail as expected\n", buf);
>  		abort();
>  	}
>  }
> 

Thanks. I queued it for 3.17 fixes.

-- Shuah

-- 
Shuah Khan
Sr. Linux Kernel Developer
Samsung Research America (Silicon Valley)
shuahkh@osg.samsung.com | (970) 217-8978
