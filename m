Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752333AbaBMRKr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 12:10:47 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:35115 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751833AbaBMRKq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 12:10:46 -0500
Date: Thu, 13 Feb 2014 17:10:25 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Madper Xie <cxie@redhat.com>
Cc: Matt Fleming <matt@console-pimps.org>, Toshi Kani <toshi.kani@hp.com>,
        Matt Fleming <matt.fleming@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Josh Triplett <josh@joshtriplett.org>
Subject: Re: [BUG] can't boot up: unable to handle kernel paging request at
 ffffffffff340003
Message-ID: <20140213171024.GA4420@srcf.ucam.org>
References: <8738jr5t3e.fsf@redhat.com>
 <20140210175246.GB2887@console-pimps.org>
 <87mwhy8iaj.fsf@redhat.com>
 <20140211131640.GD2887@console-pimps.org>
 <87lhxh69u0.fsf@redhat.com>
 <20140211141846.GA1725@console-pimps.org>
 <1392221703.5612.164.camel@misato.fc.hp.com>
 <20140213105547.GC20717@console-pimps.org>
 <87k3czdtbf.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87k3czdtbf.fsf@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 13, 2014 at 09:40:36PM +0800, Madper Xie wrote:

> Thanks Matt. This patch fix the panic. And ioremap warning disappeared
> after apply your patch.

The spec was originally unclear on what the valid bit meant - I think 
this is the right thing to do.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
