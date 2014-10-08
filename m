Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755810AbaJHP7k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 11:59:40 -0400
Received: from mail-lb0-f170.google.com ([209.85.217.170]:47284 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753987AbaJHP7i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 11:59:38 -0400
Message-ID: <54355F66.6060204@cogentembedded.com>
Date: Wed, 08 Oct 2014 19:59:34 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Masanari Iida <standby24x7@gmail.com>, linux-kernel@vger.kernel.org,
        davem@davemloft.net, netdev@vger.kernel.org
CC: dan.j.williams@intel.com
Subject: Re: [PATCH] net: description of dma_cookie cause make xmldocs warning
References: <1412780019-32475-1-git-send-email-standby24x7@gmail.com>
In-Reply-To: <1412780019-32475-1-git-send-email-standby24x7@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 10/08/2014 06:53 PM, Masanari Iida wrote:

> In commit 7bced397510ab569d31de4c70b39e13355046387,

    Please also specify that commit's summary line in parens.

> dma_cookie was removed from struct skbuff.
> But the description of dma_cookie still exist.
> So the "make xmldocs" output following warning.

> Warning(.//include/linux/skbuff.h:609): Excess struct/union
> /enum/typedef member 'dma_cookie' description in 'sk_buff'

> Remove description of dma_cookie fix the symptom.

> Signed-off-by: Masanari Iida <standby24x7@gmail.com>

WBR, Sergei

