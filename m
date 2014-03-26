Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752581AbaCZKBg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 06:01:36 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:51393 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750911AbaCZKBf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 06:01:35 -0400
Message-ID: <5332A55E.5060702@mev.co.uk>
Date: Wed, 26 Mar 2014 10:01:02 +0000
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Mozilla/5.0 (Windows NT 5.2; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Chase Southwood <chase.southwood@yahoo.com>, gregkh@linuxfoundation.org
CC: hsweeten@visionengravers.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] staging: comedi: s626: use comedi_timeout() on remaining
 loops
References: <1395724172-30183-1-git-send-email-chase.southwood@yahoo.com> <1395805438-12259-1-git-send-email-chase.southwood@yahoo.com>
In-Reply-To: <1395805438-12259-1-git-send-email-chase.southwood@yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/03/26 03:43 AM, Chase Southwood wrote:
> There were just a handful of more while loops in this file that needed
> timeouts, and this patch takes care of them.  One new callback is
> introduced, and all of the proper comedi_timeout() calls are then used.
> 
> Signed-off-by: Chase Southwood <chase.southwood@yahoo.com>
> ---
> 2: s626_i2c_handshake_eoc() can be used in s626_initialize() as noted by
> Ian.  So, s626_initialize_eoc() has been removed, and its uses swapped
> for s626_i2c_handshake_eoc().

Reviewed-by: Ian Abbott <abbotti@mev.co.uk>

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>        )=-
-=( Tel: +44 (0)161 477 1898   FAX: +44 (0)161 718 3587         )=-
