Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751422AbaAMKHf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 05:07:35 -0500
Received: from mail.mev.co.uk ([62.49.15.74]:46093 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751024AbaAMKHc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 05:07:32 -0500
Message-ID: <52D3BADE.3060907@mev.co.uk>
Date: Mon, 13 Jan 2014 10:07:26 +0000
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Chase Southwood <chase.southwood@yahoo.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC: Ian Abbott <ian.abbott@mev.co.uk>,
        "hsweeten@visionengravers.com" <hsweeten@visionengravers.com>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/3] Staging: comedi: Checkpatch cleanups in ni_mio_common.c
References: <1389412583.62399.YahooMailNeo@web164002.mail.gq1.yahoo.com>
In-Reply-To: <1389412583.62399.YahooMailNeo@web164002.mail.gq1.yahoo.com>
Content-Type: text/plain; charset="us-ascii"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-01-11 03:56, Chase Southwood wrote:
> This patch series fixes several warnings reported by checkpatch.pl in
> ni_mio_common.c of the comedi driver.
>
> Among the issues fixed:
> *Many unnecessary braces have been removed.
> *Improper indentation has been corrected.
> *Extra whitespace before semicolons has been removed.
> *Extra whitespace after function pointer name has been removed.
>
> Several checkpatch warnings still remain (mainly 80 character+ line
> lengths), but no new warnings have been introduced, and no functionality
> changes have been made.

All three patches are nice and harmless.

Reviewed-by: Ian Abbott <abbotti@mev.co.uk>

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>        )=-
-=( Tel: +44 (0)161 477 1898   FAX: +44 (0)161 718 3587         )=-
