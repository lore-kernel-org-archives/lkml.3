Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752867Ab3EGX4n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 19:56:43 -0400
Received: from www.sr71.net ([198.145.64.142]:44537 "EHLO blackbird.sr71.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750881Ab3EGX4m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 19:56:42 -0400
Message-ID: <518994B9.8020809@sr71.net>
Date: Tue, 07 May 2013 16:56:41 -0700
From: Dave Hansen <dave@sr71.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Dave Hansen <dave@sr71.net>
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, mgorman@suse.de, tim.c.chen@linux.intel.com
Subject: Re: [RFC][PATCH 7/7] drain batch list during long operations
References: <20130507211954.9815F9D1@viggo.jf.intel.com> <20130507212003.7990B2F5@viggo.jf.intel.com>
In-Reply-To: <20130507212003.7990B2F5@viggo.jf.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/07/2013 02:20 PM, Dave Hansen wrote:
> +++ linux.git-davehans/kernel/sched/fair.c	2013-05-07 13:48:15.275114295 -0700
> @@ -5211,6 +5211,8 @@ more_balance:
>  		if (sd->balance_interval < sd->max_interval)
>  			sd->balance_interval *= 2;
>  	}
> +	//if (printk_ratelimit())
> +	//	printk("sd->balance_interval: %d\n", sd->balance_interval);
>  
>  	goto out;

Urg, this is obviously a garbage hunk that snuck in here.
