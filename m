Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751221Ab3HSRr7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 13:47:59 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:51458 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751073Ab3HSRr6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 13:47:58 -0400
Date: Mon, 19 Aug 2013 18:47:43 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: David Woodhouse <dwmw2@infradead.org>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org
Subject: Re: UEFI Plugfest 2013 -- New Orleans
Message-ID: <20130819174743.GA25193@srcf.ucam.org>
References: <20130816152030.GL2133@tuxdriver.com>
 <1376900735.2322.26.camel@shinybook.infradead.org>
 <20130819125507.GA19093@srcf.ucam.org>
 <1376925765.2069.24.camel@dabdike.int.hansenpartnership.com>
 <20130819160018.GA22532@srcf.ucam.org>
 <1376931775.2069.46.camel@dabdike.int.hansenpartnership.com>
 <20130819172139.GA24393@srcf.ucam.org>
 <1376933926.2069.52.camel@dabdike.int.hansenpartnership.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1376933926.2069.52.camel@dabdike.int.hansenpartnership.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 19, 2013 at 10:38:46AM -0700, James Bottomley wrote:

> It's not about us removing the code, it's about us having an accurate
> compliance test.  There are two reasons for having a fully correct
> compliance test
> 
>      1. Our work arounds have unintended consequences which have knock
>         on effects which mean that you don't know if a test failure is
>         real or an unintended consequence of a work around.

It doesn't matter. If a platform is supposed to run Linux 3.6 then it 
has to run Linux 3.6 regardless of whether or not the failure is due to 
a firmware bug or a bug in the kernel. The platform vendor will be 
obliged to fix it in the firmware no matter what the test suite says.

>      2. New features in specs tend to build on previous features, so
>         we're going to have a hard time constructing accurate tests for
>         layered features where we've done a work around for the base
>         feature.

Which is easily rectified if the specification is modified to describe 
reality instead.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
