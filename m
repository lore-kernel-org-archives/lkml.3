Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752770AbaHKHnN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 03:43:13 -0400
Received: from 80-229-23-162.plus.com ([80.229.23.162]:48395 "EHLO
	mail.einon.net" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1752291AbaHKHnM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 03:43:12 -0400
X-Greylist: delayed 443 seconds by postgrey-1.27 at vger.kernel.org; Mon, 11 Aug 2014 03:43:11 EDT
Date: Mon, 11 Aug 2014 08:35:29 +0100
From: Mark Einon <mark.einon@gmail.com>
To: Anca Emanuel <anca.emanuel@gmail.com>
Cc: STAGING SUBSYSTEM <devel@driverdev.osuosl.org>,
        LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
        stable <stable@vger.kernel.org>, gregkh@linuxfoundation.org
Subject: Re: [PATCH RESEND] staging: et131x: Fix errors caused by
 phydev->addr accesses before initialisation
Message-ID: <20140811073529.GA4620@leicester.auvation.com>
References: <1407705415-14886-1-git-send-email-mark.einon@gmail.com>
 <CAJL_dMub6FN+HvueQ4ZJCT2TPi9-86x8VF2hG00K8CDm5bR7rw@mail.gmail.com>
 <20140811053959.GD13727@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140811053959.GD13727@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 11, 2014 at 01:39:59PM +0800, gregkh@linuxfoundation.org wrote:
> On Mon, Aug 11, 2014 at 12:32:55AM +0300, Anca Emanuel wrote:
> > Do you have this hardware ? And did you test this ?
> 
> Mark is the maintainer of this driver, I assume he has the hardware, if
> not, I don't care, I trust him :)
> 

Hi there,

:) Yes, all tested on hardware.

> > How can you cc stable without an Tested by somebody else ?
> 
> Since when is a tested-by a requirement for a stable@ marking?  Please
> read Documentation/stable_kernel_rules.txt for the details.

As Greg says, easily if you follow those rules.

Cheers,

Mark
