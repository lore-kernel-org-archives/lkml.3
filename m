Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753156AbaBXQlF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 11:41:05 -0500
Received: from mail.mev.co.uk ([62.49.15.74]:50700 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753097AbaBXQlD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 11:41:03 -0500
Message-ID: <530B7619.8090502@mev.co.uk>
Date: Mon, 24 Feb 2014 16:40:57 +0000
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Chase Southwood <chase.southwood@yahoo.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC: Ian Abbott <ian.abbott@mev.co.uk>,
        "hsweeten@visionengravers.com" <hsweeten@visionengravers.com>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3 v2] Staging: comedi: addi-data: cleanup conditional
 blocks in hwdrv_apci035.c
References: <1393039279-7229-1-git-send-email-chase.southwood@yahoo.com> <1393259653-18467-1-git-send-email-chase.southwood@yahoo.com>
In-Reply-To: <1393259653-18467-1-git-send-email-chase.southwood@yahoo.com>
Content-Type: text/plain; charset="us-ascii"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-02-24 16:34, Chase Southwood wrote:
> There were some conditional blocks that had an unnecessary level of
> indentation in them.  We can remove this to improve code clarity.
>
> Signed-off-by: Chase Southwood <chase.southwood@yahoo.com>
> ---
> 2: Moved "else if" up to the same line as closing brace of "if".  Left
> braces on single line "else if" matched to an "if" requiring braces, per
> CodingStyle.

Reviewed-by: Ian Abbott <abbotti@mev.co.uk>

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>        )=-
-=( Tel: +44 (0)161 477 1898   FAX: +44 (0)161 718 3587         )=-
