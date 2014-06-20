Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966862AbaFTK7D (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 06:59:03 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:30656 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965650AbaFTK7B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 06:59:01 -0400
Date: Fri, 20 Jun 2014 13:59:03 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: devel@driverdev.osuosl.org,
        Florian Schilhabel <florian.c.schilhabel@googlemail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Thomas Cort <linuxgeek@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH] staging: rtl8712: rtl871x_ioctl_linux.c: Cleaning up
 useless if statement
Message-ID: <20140620105903.GT5500@mwanda>
References: <1402852858-1352-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
 <20140616090525.GG5500@mwanda>
 <CAFo99gY+UQQdTiRzF8Ca9tYzcty90yHQ3paR9-67tYHcr_JZhQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFo99gY+UQQdTiRzF8Ca9tYzcty90yHQ3paR9-67tYHcr_JZhQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 20, 2014 at 12:46:33PM +0200, Rickard Strandqvist wrote:
> Hi
> 
> It's a bit confusing with this, I have received a lot of complaints
> that I have not had a cover letter.
> When should I include it? In an obvious patching. But where there's a
> need to explain anything further should have a cover letter.

Cover letters are for if you have a series of patches and they follow a
theme.  "Add support for XXX feature in a series of 8 patches".  "What
is in my pull request for the new kernel."  It's just a shorter summary.
This is just one patch not a series.

I have never sent a cover letter in my life.  I don't know who is
complaining to you...

In this case the changelog would have been better and more complete if
all the cover letter information were in the permanent commit log.

regards,
dan carpenter
