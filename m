Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757028AbaE2MNP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 08:13:15 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:57326 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753066AbaE2MNO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 08:13:14 -0400
Message-ID: <53872455.6040601@mev.co.uk>
Date: Thu, 29 May 2014 13:13:09 +0100
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Mozilla/5.0 (Windows NT 5.2; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: <driverdev-devel@linuxdriverproject.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Fred Brooks <frederick.brooks@microchip.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] staging: comedi: ni_daq_700: add AI range and input
 mode switching
References: <1401362147-5965-1-git-send-email-abbotti@mev.co.uk> <1401362147-5965-3-git-send-email-abbotti@mev.co.uk> <20140529115131.GA15585@mwanda>
In-Reply-To: <20140529115131.GA15585@mwanda>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MEVEXCHANGE.mev.local (10.0.0.4) To MEVEXCHANGE.mev.local
 (10.0.0.4)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/05/29 12:51 PM, Dan Carpenter wrote:
> These days, I don't barely look at comedi changes at all because you
> guys do such a great job.  I just had a process/git comment on this one.
> Normally, these changelogs look like:
> 
> From: Fred Brooks <frederick.brooks@microchip.com>
> 
> Add support for switching the input range and the
> single-ended/differential input mode for the AI subdevice.  We needed to
> clear the FIFO of data before the conversion to handle card mode
> switching glitches.
> 
> [ I made some style changes.  - Ian ]
> 
> If the first line of the email is From: then git assigns authorship
> credit automatically.

Okay, I'll repost it with a better comment.

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>             )=-
-=( Tel: +44 (0)161 477 1898   FAX: +44 (0)161 718 3587              )=-
