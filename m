Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753076Ab3HNGh6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 02:37:58 -0400
Received: from new2-smtp.messagingengine.com ([66.111.4.224]:47656 "EHLO
	new2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752464Ab3HNGhz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 02:37:55 -0400
X-Sasl-enc: HQVrxS0HQm1QhROSVuulm/rcpi/yZS9rkiWuLwsC2Enw 1376461679
Message-ID: <520B236D.7030704@iki.fi>
Date: Wed, 14 Aug 2013 09:27:57 +0300
From: Pekka Enberg <penberg@iki.fi>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Tang Chen <tangchen@cn.fujitsu.com>
CC: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, yinghai@kernel.org,
        jacob.shin@amd.com, x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: Use memblock_set_current_limit() to set limit for
 memblock.
References: <1376451844-15682-1-git-send-email-tangchen@cn.fujitsu.com>
In-Reply-To: <1376451844-15682-1-git-send-email-tangchen@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/14/13 6:44 AM, Tang Chen wrote:
> In setup_arch() of x86, it set memblock.current_limit directly.
> We should use memblock_set_current_limit(). If the implementation
> is changed, it is easy to maintain.
>
> Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>

Reviewed-by: Pekka Enberg <penberg@kernel.org>
