Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754165Ab3AURtp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 12:49:45 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43797 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751859Ab3AURto (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 12:49:44 -0500
Message-ID: <50FD7FA9.6080901@redhat.com>
Date: Mon, 21 Jan 2013 12:49:29 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: paul.szabo@sydney.edu.au
CC: linux-mm@kvack.org, 695182@bugs.debian.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Subtract min_free_kbytes from dirtyable memory
References: <201301210315.r0L3FnGV021298@como.maths.usyd.edu.au>
In-Reply-To: <201301210315.r0L3FnGV021298@como.maths.usyd.edu.au>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/20/2013 10:15 PM, paul.szabo@sydney.edu.au wrote:
> When calculating amount of dirtyable memory, min_free_kbytes should be
> subtracted because it is not intended for dirty pages.
>
> Using an "extern int" because that is the only interface to some such
> sysctl values.
>
> (This patch does not solve the PAE OOM issue.)
>
> Paul Szabo   psz@maths.usyd.edu.au   http://www.maths.usyd.edu.au/u/psz/
> School of Mathematics and Statistics   University of Sydney    Australia
>
> Reported-by: Paul Szabo <psz@maths.usyd.edu.au>
> Reference: http://bugs.debian.org/695182
> Signed-off-by: Paul Szabo <psz@maths.usyd.edu.au>

Acked-by: Rik van Riel <riel@redhat.com>


-- 
All rights reversed
