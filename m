Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756676AbaCEMMB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 07:12:01 -0500
Received: from mail.mev.co.uk ([62.49.15.74]:41797 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754832AbaCEMMA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 07:12:00 -0500
Message-ID: <53171483.6010106@mev.co.uk>
Date: Wed, 5 Mar 2014 12:11:47 +0000
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Chase Southwood <chase.southwood@yahoo.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC: Ian Abbott <ian.abbott@mev.co.uk>,
        "hsweeten@visionengravers.com" <hsweeten@visionengravers.com>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 2/2] Staging: comedi: propagate timeout errors in s626.c
References: <1393572936-9676-1-git-send-email-chase.southwood@yahoo.com> <1393922642-27948-1-git-send-email-chase.southwood@yahoo.com>
In-Reply-To: <1393922642-27948-1-git-send-email-chase.southwood@yahoo.com>
Content-Type: text/plain; charset="us-ascii"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-03-04 08:44, Chase Southwood wrote:
> This patch for s626.c propagates the errors from the newly introduced
> calls to comedi_timeout() as far as possible.
>
> Signed-off-by: Chase Southwood <chase.southwood@yahoo.com>
> ---
> Compile tested only.

Looks good, but if you change patch 1 this one will need rebasing to it.

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>        )=-
-=( Tel: +44 (0)161 477 1898   FAX: +44 (0)161 718 3587         )=-
