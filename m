Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759235AbaELRK6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 13:10:58 -0400
Received: from mail-ig0-f181.google.com ([209.85.213.181]:59012 "EHLO
	mail-ig0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759216AbaELRK5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 13:10:57 -0400
Message-ID: <5371009E.9060500@linaro.org>
Date: Mon, 12 May 2014 10:10:54 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Fabian Frederick <fabf@skynet.be>,
        linux-kernel <linux-kernel@vger.kernel.org>
CC: akpm <akpm@linux-foundation.org>
Subject: Re: [PATCH V2] kernel/time/ntp.c: convert simple_strtol to kstrtol
References: <20140509203225.cc19cf4bc46e3d2647e5ad5f@skynet.be>
In-Reply-To: <20140509203225.cc19cf4bc46e3d2647e5ad5f@skynet.be>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/09/2014 11:32 AM, Fabian Frederick wrote:
> Replace obsolete function
>
> Inspired-By: Andrew Morton <akpm@linux-foundation.org>
> Cc: John Stultz <john.stultz@linaro.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Fabian Frederick <fabf@skynet.be>
> ---
> V2
> 	-Add patch description

Queued in my for-3.16 branch.

thanks
-john

