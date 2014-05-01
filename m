Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751917AbaEADoM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 23:44:12 -0400
Received: from mail-ee0-f50.google.com ([74.125.83.50]:48351 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751158AbaEADoL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 23:44:11 -0400
Date: Thu, 1 May 2014 05:43:58 +0200
From: Richard Cochran <richardcochran@gmail.com>
To: Mark Brown <broonie@kernel.org>
Cc: Xiubo Li <Li.Xiubo@freescale.com>, mark.rutland@arm.com,
        gregkh@linuxfoundation.org, mpa@pengutronix.de,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv3 0/2] add DT endianness binding support
Message-ID: <20140501034358.GA4514@netboy>
References: <1398833029-29546-1-git-send-email-Li.Xiubo@freescale.com>
 <20140430071011.GA7312@netboy>
 <20140430182500.GD3245@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140430182500.GD3245@sirena.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 30, 2014 at 11:25:00AM -0700, Mark Brown wrote:
> On Wed, Apr 30, 2014 at 09:10:12AM +0200, Richard Cochran wrote:
> > Shouldn't this go to the arm list and rmk for review, too?
> 
> Is there any particular reason for including rmk?  It's generally not
> helpful to spam people with serieses without reason, we all get quite a
> lot of mail already...

I recall seeing him writing at length about cpu/peripheral endianness
issues, so I assume he has some expertise here. It would be a shame if
a new DT feature were overlooking something important.

Thanks,
Richard
