Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757614AbaD2NVQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 09:21:16 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:49076 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751696AbaD2NVP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 09:21:15 -0400
Message-ID: <535FA73B.6090501@mev.co.uk>
Date: Tue, 29 Apr 2014 14:20:59 +0100
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Chase Southwood <chase.southwood@gmail.com>, <gregkh@linuxfoundation.org>
CC: <hsweeten@visionengravers.com>, <devel@driverdev.osuosl.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 6/6 v2] staging: comedi: addi_apci_1564: remove use of
 devpriv->s_EeParameters
References: <1398562711-6313-1-git-send-email-chase.southwood@gmail.com> <1398760700-19397-1-git-send-email-chase.southwood@gmail.com>
In-Reply-To: <1398760700-19397-1-git-send-email-chase.southwood@gmail.com>
Content-Type: text/plain; charset="us-ascii"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MEVEXCHANGE.mev.local (10.0.0.4) To MEVEXCHANGE.mev.local
 (10.0.0.4)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-04-29 09:38, Chase Southwood wrote:
> This driver no longer reads the eeprom to find the board specific data,
> all the necessary data is in the boardinfo. Use the boardinfo directly
> instead of passing through devpriv->s_EeParameters.
>
> Signed-off-by: Chase Southwood <chase.southwood@gmail.com>
> Cc: Ian Abbott <abbotti@mev.co.uk>
> Cc: H Hartley Sweeten <hsweeten@visionengravers.com>
> ---
> 2: Incorrect patch title fixed.
>
> Ian and Hartley,
>
> The auto_attach() function is starting to look much better now.  My next patchset
> will be geared towards only allocating subdevices which are actually used.

Great!  All looking good except the description of PATCH 4/6 v2.

Revie

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>        )=-
-=( Tel: +44 (0)161 477 1898   FAX: +44 (0)161 718 3587         )=-
