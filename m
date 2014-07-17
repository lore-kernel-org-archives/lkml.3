Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757210AbaGQLqX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 07:46:23 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43465 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754655AbaGQLqV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 07:46:21 -0400
Date: Thu, 17 Jul 2014 13:46:18 +0200
From: Petr =?iso-8859-1?Q?Ml=E1dek?= <pmladek@suse.cz>
To: Alex Elder <elder@linaro.org>
Cc: akpm@linux-foundation.org, bp@suse.de, john.stultz@linaro.org,
        jack@suse.cz, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] printk: correct some more typos
Message-ID: <20140717114618.GS6774@pathway.suse.cz>
References: <1405531620-9983-1-git-send-email-elder@linaro.org>
 <1405531620-9983-5-git-send-email-elder@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1405531620-9983-5-git-send-email-elder@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2014-07-16 12:27:00, Alex Elder wrote:
> This patch corrects a few more typographical errors in "printk.c".
> 
> Signed-off-by: Alex Elder <elder@linaro.org>
> ---
>  kernel/printk/printk.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
> index 3f15d95..0cbd060 100644
> --- a/kernel/printk/printk.c
> +++ b/kernel/printk/printk.c
> @@ -201,7 +201,7 @@ static int console_may_schedule;
>   *
>   * The optional key/value pairs are attached as continuation lines starting
>   * with a space character and terminated by a newline. All possible
> - * non-prinatable characters are escaped in the "\xff" notation.
> + * non-printable characters are escaped in the "\xff" notation.
>   *
>   * Users of the export format should ignore possible additional values
>   * separated by ',', and find the message after the ';' character.
> @@ -411,7 +411,7 @@ static int log_store(int facility, int level,
>  		/* truncate the message if it is too long for empty buffer */
>  		size = truncate_msg(&text_len, &trunc_msg_len,
>  				    &dict_len, &pad_len);
> -		/* survive when the log buffer is too small for trunc_msg */
> +		/* survive when the log buffer is too small for truncate_msg */

It meant the trunc_msg = "<truncated>" string. So, the original text
was more precise. I agree that it is a bit confusing :-)

The other changes look correct.

Best Regards,
Petr

>  		if (log_make_free_space(size))
>  			return 0;
>  	}
> @@ -614,7 +614,7 @@ static ssize_t devkmsg_read(struct file *file, char __user *buf,
>  	/*
>  	 * If we couldn't merge continuation line fragments during the print,
>  	 * export the stored flags to allow an optional external merge of the
> -	 * records. Merging the records isn't always neccessarily correct, like
> +	 * records. Merging the records isn't always necessarily correct, like
>  	 * when we hit a race during printing. In most cases though, it produces
>  	 * better readable output. 'c' in the record flags mark the first
>  	 * fragment of a line, '+' the following.
> @@ -2881,7 +2881,7 @@ bool kmsg_dump_get_buffer(struct kmsg_dumper *dumper, bool syslog,
>  		prev = msg->flags;
>  	}
>  
> -	/* last message in next interation */
> +	/* last message in next iteration */
>  	next_seq = seq;
>  	next_idx = idx;
>  
> @@ -2907,7 +2907,7 @@ out:
>  EXPORT_SYMBOL_GPL(kmsg_dump_get_buffer);
>  
>  /**
> - * kmsg_dump_rewind_nolock - reset the interator (unlocked version)
> + * kmsg_dump_rewind_nolock - reset the iterator (unlocked version)
>   * @dumper: registered kmsg dumper
>   *
>   * Reset the dumper's iterator so that kmsg_dump_get_line() and
> @@ -2925,7 +2925,7 @@ void kmsg_dump_rewind_nolock(struct kmsg_dumper *dumper)
>  }
>  
>  /**
> - * kmsg_dump_rewind - reset the interator
> + * kmsg_dump_rewind - reset the iterator
>   * @dumper: registered kmsg dumper
>   *
>   * Reset the dumper's iterator so that kmsg_dump_get_line() and
> -- 
> 1.9.1
> 
