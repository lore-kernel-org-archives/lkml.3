Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933624AbaEFB0V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 21:26:21 -0400
Received: from ozlabs.org ([103.22.144.67]:42614 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933602AbaEFB0U convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 21:26:20 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Brian W Hart <hartb@linux.vnet.ibm.com>, tj@kernel.org,
        linux-kernel@vger.kernel.org, trivial@kernel.org
Subject: Re: [PATCH v2] cpumask.h: silence warning with -Wsign-compare
In-Reply-To: <20140505152113.GB9463@oc3347516403.ibm.com>
References: <20140505152113.GB9463@oc3347516403.ibm.com>
User-Agent: Notmuch/0.17 (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Tue, 06 May 2014 10:31:02 +0930
Message-ID: <87bnvbbu0h.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Brian W Hart <hartb@linux.vnet.ibm.com> writes:
> Silence the warning when building with -Wsign-compare when cpumask.h
> is included:
>
> include/linux/cpumask.h: In function ‘cpumask_parse’:
> include/linux/cpumask.h:603:26: warning: signed and unsigned type in conditional
> +expression [-Wsign-compare]
>   int len = nl ? nl - buf : strlen(buf);
>                           ^
>
> V2: Rusty pointed out that unsigned should be used instead.

Thanks, applied.

Cheers,
Rusty.
