Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755202AbaAURNJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 12:13:09 -0500
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:32910 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754788AbaAURNG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 12:13:06 -0500
Date: Tue, 21 Jan 2014 17:12:34 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "H.J. Lu" <hjl.tools@gmail.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/8] Use __kernel_long_t in struct timex
Message-ID: <20140121171233.GE20798@arm.com>
References: <1388165112-6545-1-git-send-email-hjl.tools@gmail.com>
 <1388165112-6545-2-git-send-email-hjl.tools@gmail.com>
 <20140121165803.GC20798@arm.com>
 <52DEA84D.2090306@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52DEA84D.2090306@zytor.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 21, 2014 at 05:03:09PM +0000, H. Peter Anvin wrote:
> On 01/21/2014 08:58 AM, Catalin Marinas wrote:
> > BTW, could we not avoid the #if and always use __kernel_long_t? This
> > wouldn't break the user ABI.
> 
> Ah yes, this is the wrong version of the patchset.  I already gave that
> feedback and H.J. posted an update.  My bad.

Ah, I have to dig a newer version then.

-- 
Catalin
