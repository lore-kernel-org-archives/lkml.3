Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758327AbaGCPBN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 11:01:13 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36821 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754358AbaGCPBL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 11:01:11 -0400
Message-ID: <53B57035.3020200@suse.cz>
Date: Thu, 03 Jul 2014 17:01:09 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Thomas Schoebel-Theuer <tst@schoebel-theuer.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 06/50] mars: add new file drivers/block/mars/brick_mem.c
References: <1404251250-22992-1-git-send-email-tst@schoebel-theuer.de> <1404251250-22992-7-git-send-email-tst@schoebel-theuer.de>
In-Reply-To: <1404251250-22992-7-git-send-email-tst@schoebel-theuer.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-07-01 23:46, Thomas Schoebel-Theuer wrote:
> +#ifdef CONFIG_MARS_DEBUG_MEM_STRONG
> +# define STRING_CANARY							\
> +	"xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx" \
> +	"yyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy" \
> +	"zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz" \
> +	"xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx" \
> +	"yyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy" \
> +	"zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz" \
> +	"xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx" \
> +	"yyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy" \
> +	"zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz" \
> +	" FILE = "	__FILE__					\
> +	" DATE = "	__DATE__					\
> +	" TIME = "	__TIME__					\

The kernel is built with -Werror=date-time nowadays, so this is not
going to work.

Michal
