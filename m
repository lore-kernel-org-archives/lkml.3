Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757564AbaHGJ4S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 05:56:18 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:39635 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757487AbaHGJ4Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 05:56:16 -0400
Message-ID: <53E34D3A.2090805@mev.co.uk>
Date: Thu, 7 Aug 2014 10:56:10 +0100
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Mozilla/5.0 (Windows NT 5.2; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Niklas Svensson <nks@flawful.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: H Hartley Sweeten <hsweeten@visionengravers.com>,
        Raghavendra Ganiga <ravi23ganiga@gmail.com>,
        <devel@driverdev.osuosl.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] staging: comedi: fixing coding style problems
References: <1407347710-11460-1-git-send-email-nks@flawful.org>
In-Reply-To: <1407347710-11460-1-git-send-email-nks@flawful.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MEVEXCHANGE.mev.local (10.0.0.4) To MEVEXCHANGE.mev.local
 (10.0.0.4)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/08/06 06:55 PM, Niklas Svensson wrote:
> This patch fixes warnings of checkpatch.pl script:
> 
> CHECK:UNNECESSARY_PARENTHESES: Unnecessary parentheses around devpriv->timer
> +        init_timer(&(devpriv->timer));
> 
> CHECK:PARENTHESIS_ALIGNMENT: Alignment should match open parenthesis
> +        dev_info(dev->class_dev,
> +                "%s: %i microvolt, %li microsecond waveform attached\n",
> 
> Task of Eudyptula challenge.
> 
> Signed-off-by: Niklas Svensson <nks@flawful.org>

Reviewed-by: Ian Abbott <abbotti@mev.co.uk>

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>             )=-
-=( Tel: +44 (0)161 477 1898   FAX: +44 (0)161 718 3587              )=-
