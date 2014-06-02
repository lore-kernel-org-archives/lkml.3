Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752501AbaFBHjX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 03:39:23 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:40605 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751442AbaFBHjW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 03:39:22 -0400
Date: Mon, 2 Jun 2014 10:39:04 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Xenia Ragiadakou <burzalodowa@gmail.com>,
        Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>,
        Ana Rey <anarey@gmail.com>, Teodora Baluta <teobaluta@gmail.com>,
        Andrea Merello <andrea.merello@gmail.com>, devel@driverdev.osuosl.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] staging: rtl8192u: r8192U_core.c: Cleaning up
 uninitialized variables
Message-ID: <20140602073904.GQ17724@mwanda>
References: <1401629315-18843-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
 <20140601203703.GO17724@mwanda>
 <CAFo99gZEDeXZvdmkESrQ0CSME4wEZ3WSEJmJ-FoJVXOhK=zzcQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFo99gZEDeXZvdmkESrQ0CSME4wEZ3WSEJmJ-FoJVXOhK=zzcQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 01, 2014 at 11:05:39PM +0200, Rickard Strandqvist wrote:
> Hi Dan
> 
> I agree, this looks strange.
> Have been looking for a while in history with, to see if the code has
> been removed. I start my search using cppcheck for over three months
> ago.
> But could not find anything. Sorry about that :-(
> 
> But I'll make a patch that completely removes testing variable then instead?

Yes.  Btw, what do the cppcheck error messages for this look like
anyway?

regards,
dan carpenter

