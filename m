Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753139AbaCKO1m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 10:27:42 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:51927 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753028AbaCKO1k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 10:27:40 -0400
Message-ID: <531F1D59.2080703@mev.co.uk>
Date: Tue, 11 Mar 2014 14:27:37 +0000
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Chase Southwood <chase.southwood@yahoo.com>, gregkh@linuxfoundation.org
CC: hsweeten@visionengravers.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/2] Staging: comedi: propagate timeout errors in s626.c
References: <1393922628-27903-1-git-send-email-chase.southwood@yahoo.com> <1394242997-32612-1-git-send-email-chase.southwood@yahoo.com>
In-Reply-To: <1394242997-32612-1-git-send-email-chase.southwood@yahoo.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-03-08 01:43, Chase Southwood wrote:
> This patch for s626.c propagates the errors from the newly introduced
> calls to comedi_timeout() as far as possible.
>
> Signed-off-by: Chase Southwood <chase.southwood@yahoo.com>
> ---
> Compile tested.
>
> 2: This patch was introduced in v2 of this set.
>
> 3: Rebased on top of PATCH 1/2 edits.

Reviewed-by: Ian Abbott <abbotti@mev.co.uk>

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>        )=-
-=( Tel: +44 (0)161 477 1898   FAX: +44 (0)161 718 3587         )=-
