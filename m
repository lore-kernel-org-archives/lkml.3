Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753145AbaBZRLI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 12:11:08 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:40662 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752660AbaBZRLG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 12:11:06 -0500
Date: Wed, 26 Feb 2014 17:10:53 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Chris Bainbridge <chris.bainbridge@gmail.com>, davej@redhat.com,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: set Pentium M as PAE capable
Message-ID: <20140226171053.GA22567@srcf.ucam.org>
References: <20140225060146.GA4339@debian.local>
 <530C7465.2080600@zytor.com>
 <20140225162611.GA31902@redhat.com>
 <530CCFD2.3050007@zytor.com>
 <20140226121256.GA8494@debian.local>
 <20140226164433.GA19341@srcf.ucam.org>
 <530E1A35.40506@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <530E1A35.40506@zytor.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 26, 2014 at 08:45:41AM -0800, H. Peter Anvin wrote:

> Yes.  Grub can be made to behave sanely by using "linux16" and
> "initrd16", but of course none of the distros do it that way.

Fedora does as of F20, but yeah, point taken.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
