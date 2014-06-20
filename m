Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967513AbaFTMFm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 08:05:42 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:49757 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967160AbaFTMFk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 08:05:40 -0400
Message-ID: <53A4238E.7040505@mev.co.uk>
Date: Fri, 20 Jun 2014 13:05:34 +0100
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: <driverdev-devel@linuxdriverproject.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        <linux-kernel@vger.kernel.org>,
        Fred Brooks <frederick.brooks@microchip.com>
Subject: Re: [PATCH 2/2 v3] staging: comedi: ni_daq_700: add AI range and
 input mode switching
References: <20140618213801.GA11436@kroah.com> <1403265195-32693-1-git-send-email-abbotti@mev.co.uk>
In-Reply-To: <1403265195-32693-1-git-send-email-abbotti@mev.co.uk>
Content-Type: text/plain; charset="us-ascii"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MEVEXCHANGE.mev.local (10.0.0.4) To MEVEXCHANGE.mev.local
 (10.0.0.4)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-06-20 12:53, Ian Abbott wrote:
> From: Fred Brooks <frederick.brooks@microchip.com>
>
> Add support for switching the input range and the single-ended/
> differential input mode for the AI subdevice.  We needed to clear the
> FIFO of data before the conversion to handle card mode switching
> glitches.
>
> [ Minor whitespace fixes and driver comment reformatting.  - Ian ]
>
> Signed-off-by: Fred Brooks <frederick.brooks@microchip.com>
> Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
> ---
> v2: Set authorship to Fred Brooks and updated patch description as
> suggested by Dan Carpenter.
> v3: Rebased to fix merge conflict with "staging: comedi: ni_daq_700: add
> mux settling delay" patch.  The channel number ('chan') doesn't need
> ANDing with 0xf as it will be less than 16.

I forgot to add:

Reviewed-by: H Hartley Sweeten <hsweeten@visionengravers.com>

from his reply to the v2 patch.

I'll strip out the the module version information in a subsequent patch. 
  I don't think the minor code formatting niggles matter enough to worry 
about.

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>        )=-
-=( Tel: +44 (0)161 477 1898   FAX: +44 (0)161 718 3587         )=-
