Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754924AbbAPSRQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 13:17:16 -0500
Received: from mail-la0-f42.google.com ([209.85.215.42]:37532 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751707AbbAPSRO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 13:17:14 -0500
Message-ID: <54B955A5.3090901@cogentembedded.com>
Date: Fri, 16 Jan 2015 21:17:09 +0300
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Simon Kelley <simon@thekelleys.org.uk>,
        Kalle Valo <kvalo@codeaurora.org>
CC: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: wireless: atmel: Remove open-coded and wrong strcasecmp
References: <1421414907-26764-1-git-send-email-linux@rasmusvillemoes.dk>
In-Reply-To: <1421414907-26764-1-git-send-email-linux@rasmusvillemoes.dk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 01/16/2015 04:28 PM, Rasmus Villemoes wrote:

> The kernel's string library does in fact have strcasecmp, at least
> since ded220bd8f08. Moreover, this open-coded version is in fact

    Please also specify that commit's summary line in parens.

> wrong: If the strings only differ in their last character, a and b
> have already been incremented to point to the terminating nul bytes,

    NUL.

> so they would be treated as equal.

> Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>

[...]

WBR, Sergei

