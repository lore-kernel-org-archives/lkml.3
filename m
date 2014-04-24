Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755559AbaDXJXE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 05:23:04 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:47480 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755450AbaDXJW5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 05:22:57 -0400
Message-ID: <5358D7EA.3030305@mev.co.uk>
Date: Thu, 24 Apr 2014 10:22:50 +0100
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Chase Southwood <chase.southwood@yahoo.com>, <gregkh@linuxfoundation.org>
CC: <hsweeten@visionengravers.com>, <devel@driverdev.osuosl.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] staging: comedi: addi_apci_1564: separate from addi_common.c
References: <1398323941-2596-1-git-send-email-chase.southwood@yahoo.com>
In-Reply-To: <1398323941-2596-1-git-send-email-chase.southwood@yahoo.com>
Content-Type: text/plain; charset="us-ascii"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MEVEXCHANGE.mev.local (10.0.0.4) To MEVEXCHANGE.mev.local
 (10.0.0.4)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-04-24 08:19, Chase Southwood wrote:
> Using the addi-data "common" code in addi_apci_1564 introduces a lot of
> bloat.  By separating this driver off from addi_common.c, a lot of the
> common code can be stripped out.  This patch copies the code over from
> addi_common.c, and removes the #include of the file.  The auto_attach
> function from the common code replaces the one that was previously in this
> driver, though renamed to that it stays within the namespace associated
> with this driver, and the detach function has been renamed for this reason
> as well.
>
> Signed-off-by: Chase Southwood <chase.southwood@yahoo.com>
> Cc: H Hartley Sweeten <hsweeten@visionengravers.com>
> Cc: Ian Abbott <abbotti@mev.co.uk>
> ---
> Compile tested only.

Reviewed-by: Ian Abbott <abbotti@mev.co.uk>

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>        )=-
-=( Tel: +44 (0)161 477 1898   FAX: +44 (0)161 718 3587         )=-
