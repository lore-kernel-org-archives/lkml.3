Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752819AbaBOKgn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Feb 2014 05:36:43 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:33392 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752100AbaBOKgl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Feb 2014 05:36:41 -0500
Date: Sat, 15 Feb 2014 13:36:23 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Levente Kurusa <levex@linux.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        OSUOSL Drivers <devel@driverdev.osuosl.org>
Subject: Re: [PATCH] [RFC] staging: rtl8821ae: fix invalid bit mask on MSR_AP
 check
Message-ID: <20140215103623.GE26722@mwanda>
References: <1392414623-4369-1-git-send-email-levex@linux.com>
 <20140214220041.GD26722@mwanda>
 <52FF1CFE.40504@linux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52FF1CFE.40504@linux.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 15, 2014 at 08:53:34AM +0100, Levente Kurusa wrote:
> Thanks Dan, maybe you know some people who could test it?
> RTLXXXXXX guys? Or maybe we can take the patch as is?
> I cannot really think of any other solution other than removing
> the other clause, but since that was written to the file,
> there must have been some logic behind that. I am slightly
> disappointed get_maintainer didn't really find anybody for
> this patch...

This driver is going to be deleted in the next couple weeks and replaced
with a re-written from scratch driver.

Your fix is correct.  It's just that no one tested the AP code for this.
I would feel comfortable applying it as-is if no one is available to
test it.

regards,
dan carpenter

