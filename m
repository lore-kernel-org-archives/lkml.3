Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756150Ab3AQSwL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 13:52:11 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46459 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752104Ab3AQSwJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 13:52:09 -0500
Date: Thu, 17 Jan 2013 18:51:56 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: Joseph Salisbury <joseph.salisbury@canonical.com>
Cc: LKML <linux-kernel@vger.kernel.org>, pkondeti@codeaurora.org,
        Greg KH <gregkh@linuxfoundation.org>,
        Herton Krzesinski <herton.krzesinski@canonical.com>,
        stable@vger.kernel.org, stern@rowland.harvard.edu,
        linux-usb@vger.kernel.org
Message-ID: <20130117185156.GK13292@decadent.org.uk>
References: <50F84441.8080300@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50F84441.8080300@canonical.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ben@decadent.org.uk
Subject: Re: [REVERT][v3.x.y] EHCI: Update qTD next pointer in QH overlay
 region during unlink
X-SA-Exim-Version: 4.2.1 (built Mon, 22 Mar 2010 06:51:10 +0000)
X-SA-Exim-Scanned: Yes (on shadbolt.decadent.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 17, 2013 at 01:34:41PM -0500, Joseph Salisbury wrote:
> Hello,
> 
> Please consider reverting commit
> 3d037774b42ed677f699b1dce7d548d55f4e4c2b in mainline as well as in
> the current stable releases.  It was included upstream as of
> v3.6-rc6.  This commit introduced a regression, described in the
> following bug report:
> 
> http://bugs.launchpad.net/bugs/1088733
> 
> Reverting commit 3d037774b42ed677f699b1dce7d548d55f4e4c2b in the
> v3.2 kernel has been confirmed to resolve the aforementioned bug.
 
If it's wrong in mainline then the revert needs to be done there
and cc'd to stable.  We only revert directly in stable branches if
the revert is not appropriate in mainline.

Ben.

-- 
Ben Hutchings
We get into the habit of living before acquiring the habit of thinking.
                                                              - Albert Camus
