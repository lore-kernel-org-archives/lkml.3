Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752868AbaCKPXL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 11:23:11 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:52150 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750967AbaCKPXJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 11:23:09 -0400
Message-ID: <531F2A4F.8010902@mev.co.uk>
Date: Tue, 11 Mar 2014 15:22:55 +0000
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Conrad Meyer <cemeyer@uw.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: H Hartley Sweeten <hsweeten@visionengravers.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Conrad Meyer <cse.cem@gmail.com>
Subject: Re: [PATCH] Staging: comedi: fixup: dev_warn() with correct dev
References: <531F1B76.6010608@mev.co.uk> <1394549897-15186-1-git-send-email-cse.cem@gmail.com>
In-Reply-To: <1394549897-15186-1-git-send-email-cse.cem@gmail.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-03-11 14:58, Conrad Meyer wrote:
> Replace hw_dev with class_dev in new dev_warn()s.
>
> Sending this as a patch on top of the one already applied, since GregKH already
> took that one. If this is the wrong way to fix it, please let me know how I
> should proceed, I'm new.
>
> Thanks!
>
> Signed-off-by: Conrad Meyer <cse.cem@gmail.com>

Reviewed-by: Ian Abbott <abbotti@mev.co.uk>

Though only the patch subject, the first line of the description and the 
Signed-off-by line are relevant.  All the other stuff should have gone 
between the Signed-off-by (and similar) line(s) and the actual patch, 
separated by three dashes like this:

Signed-off-by: x
---
Commentary that shouldn't go in the commit message goes here.
---
start of patch goes here.

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>        )=-
-=( Tel: +44 (0)161 477 1898   FAX: +44 (0)161 718 3587         )=-
