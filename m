Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753098AbaBZQoy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 11:44:54 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:40111 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752563AbaBZQox (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 11:44:53 -0500
Date: Wed, 26 Feb 2014 16:44:33 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Chris Bainbridge <chris.bainbridge@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, davej@redhat.com, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: set Pentium M as PAE capable
Message-ID: <20140226164433.GA19341@srcf.ucam.org>
References: <20140225060146.GA4339@debian.local>
 <530C7465.2080600@zytor.com>
 <20140225162611.GA31902@redhat.com>
 <530CCFD2.3050007@zytor.com>
 <20140226121256.GA8494@debian.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140226121256.GA8494@debian.local>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 26, 2014 at 07:12:59PM +0700, Chris Bainbridge wrote:

> The basic findings of the bug discussion is that people are successfully
> running PAE kernels on Pentium M (for some unknown reason Grub skips the
> validate_cpu code in the kernel, so existing PAE kernels will run
> unmodified, although they do fail when booted with syslinux), and people
> are using a user-space hack to add "pae" to /proc/cpuinfo.

grub is jumping to the 32-bit entry point and skipping the entire real 
mode setup code. Bad grub.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
