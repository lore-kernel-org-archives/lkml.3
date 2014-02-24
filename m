Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752893AbaBXOOf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 09:14:35 -0500
Received: from mail.mev.co.uk ([62.49.15.74]:50324 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752664AbaBXOOd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 09:14:33 -0500
Message-ID: <530B53C2.9000002@mev.co.uk>
Date: Mon, 24 Feb 2014 14:14:26 +0000
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Chase Southwood <chase.southwood@yahoo.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC: Ian Abbott <ian.abbott@mev.co.uk>,
        "hsweeten@visionengravers.com" <hsweeten@visionengravers.com>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] Staging: comedi: addi-data: fix a couple of lines
 that are too long
References: <1393039229-7184-1-git-send-email-chase.southwood@yahoo.com> <1393039316-7274-1-git-send-email-chase.southwood@yahoo.com>
In-Reply-To: <1393039316-7274-1-git-send-email-chase.southwood@yahoo.com>
Content-Type: text/plain; charset="us-ascii"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-02-22 03:21, Chase Southwood wrote:
> There are a couple of cases where a comment being on the same line as a
> statement is causing the line to be over 80 characters long.  This is an
> easy fix; move these comments to the previous line.
>
> Signed-off-by: Chase Southwood <chase.southwood@yahoo.com>

Reviewed-by: Ian Abbott <abbotti@mev.co.uk>

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>        )=-
-=( Tel: +44 (0)161 477 1898   FAX: +44 (0)161 718 3587         )=-
