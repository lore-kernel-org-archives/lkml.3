Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753470AbaC1VQn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 17:16:43 -0400
Received: from mail-ie0-f171.google.com ([209.85.223.171]:63208 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753122AbaC1VQl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 17:16:41 -0400
Message-ID: <5335E6CE.9030008@linaro.org>
Date: Fri, 28 Mar 2014 16:17:02 -0500
From: Alex Elder <elder@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: linux@arm.linux.org.uk, linus.walleij@linaro.org, viresh.linux@gmail.com,
        shiraz.hashim@gmail.com, catalin.marinas@arm.com
CC: spear-devel@list.st.com, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/7] ARM: SMP: common "pen" secondary release method
References: <1396041180-29897-1-git-send-email-elder@linaro.org>
In-Reply-To: <1396041180-29897-1-git-send-email-elder@linaro.org>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/28/2014 04:12 PM, Alex Elder wrote:
> This series proposes creating a single implementation of the "pen
> release" (or spin-table) mechanism for starting secondary CPUs on

. . .

>   	
>   ARM: spear: use central SMP spin-table routines
>     This is straightforward as well, but it depends on the
>     two prerequisite patches mentioned above (which together
>     make this code roughly identical to the rest).

Here are the patches, which I neglected to mention after all:

    http://www.spinics.net/lists/arm-kernel/msg315833.html
    http://www.spinics.net/lists/arm-kernel/msg318735.html

