Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756186AbaFRVeE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 17:34:04 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:42316 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755408AbaFRVeC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 17:34:02 -0400
Date: Wed, 18 Jun 2014 14:38:01 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Ian Abbott <abbotti@mev.co.uk>
Cc: driverdev-devel@linuxdriverproject.org,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        Fred Brooks <frederick.brooks@microchip.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2 v2] staging: comedi: ni_daq_700: add AI range and
 input mode switching
Message-ID: <20140618213801.GA11436@kroah.com>
References: <1401362147-5965-3-git-send-email-abbotti@mev.co.uk>
 <1401366566-6209-1-git-send-email-abbotti@mev.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1401366566-6209-1-git-send-email-abbotti@mev.co.uk>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 29, 2014 at 01:29:26PM +0100, Ian Abbott wrote:
> From: Fred Brooks <frederick.brooks@microchip.com>
> 
> Add support for switching the input range and the single-ended/
> differential input mode for the AI subdevice.  We needed to clear the
> FIFO of data before the conversion to handle card mode switching
> glitches.
> 
> [ Minor whitespace fixes and driver comment reformatting.  - Ian ]

This patch doesn't apply to the tree for some odd reason.  Care to
refresh it and resend?

thanks,

greg k-h
