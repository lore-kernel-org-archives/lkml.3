Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932444AbaE2Lvy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 07:51:54 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:26178 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753882AbaE2Lvx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 07:51:53 -0400
Date: Thu, 29 May 2014 14:51:31 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Ian Abbott <abbotti@mev.co.uk>
Cc: driverdev-devel@linuxdriverproject.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Fred Brooks <frederick.brooks@microchip.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] staging: comedi: ni_daq_700: add AI range and input
 mode switching
Message-ID: <20140529115131.GA15585@mwanda>
References: <1401362147-5965-1-git-send-email-abbotti@mev.co.uk>
 <1401362147-5965-3-git-send-email-abbotti@mev.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1401362147-5965-3-git-send-email-abbotti@mev.co.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These days, I don't barely look at comedi changes at all because you
guys do such a great job.  I just had a process/git comment on this one.
Normally, these changelogs look like:

From: Fred Brooks <frederick.brooks@microchip.com>

Add support for switching the input range and the
single-ended/differential input mode for the AI subdevice.  We needed to
clear the FIFO of data before the conversion to handle card mode
switching glitches.

[ I made some style changes.  - Ian ]

If the first line of the email is From: then git assigns authorship
credit automatically.

regards,
dan carpenter

