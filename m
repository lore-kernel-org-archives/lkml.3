Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751772Ab3HTRL7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 13:11:59 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:38927 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751226Ab3HTRL6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 13:11:58 -0400
Date: Tue, 20 Aug 2013 18:11:48 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Richard Yao <ryao@gentoo.org>
Cc: chanho.min@lge.com, Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: Why are BSD-licensed LZ4 symbols GPL exported?
Message-ID: <20130820171148.GA17832@srcf.ucam.org>
References: <520D8C4C.7000704@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <520D8C4C.7000704@gentoo.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 15, 2013 at 10:19:56PM -0400, Richard Yao wrote:
> Why are the LZ4 symbols being GPL-exported when the LZ4 code is
> BSD-licensed and no substantial changes appear to have been made when it
> was merged?

EXPORT_SYMBOL_GPL is intended an indication that using a symbol is 
likely to result in you producing a derived work of the kernel, and the 
kernel as a whole is under the GPL. It has nothing to do with additional 
licenses that individual pieces of code may be available under.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
