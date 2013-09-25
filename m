Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755270Ab3IYWxO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 18:53:14 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:60536 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752399Ab3IYWxN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 18:53:13 -0400
Date: Wed, 25 Sep 2013 23:53:02 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Alexander Holler <holler@ahsoftware.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Anton Altaparmakov <aia21@cam.ac.uk>,
        STAGING SUBSYSTEM <devel@driverdev.osuosl.org>,
        Benjamin Valentin <benpicco@zedat.fu-berlin.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] add exFAT driver
Message-ID: <20130925225301.GA14839@srcf.ucam.org>
References: <20130830154205.GA1411@kroah.com>
 <20130925183632.08a0d073@rechenknecht2k7>
 <20130925172704.GB5258@kroah.com>
 <20130925183235.GA9659@srcf.ucam.org>
 <20130925184539.GA4208@kroah.com>
 <52433978.9050302@ahsoftware.de>
 <20130925202151.GA6149@kroah.com>
 <57387214-F138-4471-996E-3FB1ED28346C@cam.ac.uk>
 <20130925221006.GB32312@kroah.com>
 <524363AF.1040502@ahsoftware.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <524363AF.1040502@ahsoftware.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 26, 2013 at 12:29:03AM +0200, Alexander Holler wrote:
> Am 26.09.2013 00:10, schrieb Greg Kroah-Hartman:
> 
> > Please stick to technical discussions about the code on the kernel
> > mailing lists.  Legal discussions can be left up to the lawyers, of
> > which we are not.
> 
> Hmm, but I would like to know if someone has to fear getting owned by
> Microsoft if he would use that driver.

Nobody should ever assume that any piece of code they receive is free of 
third party patent claims, no matter where the code came from.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
