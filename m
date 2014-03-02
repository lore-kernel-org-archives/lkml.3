Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753483AbaCBCXs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2014 21:23:48 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:36132 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753373AbaCBCXq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2014 21:23:46 -0500
Date: Sun, 2 Mar 2014 02:23:34 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Li, Aubrey" <aubrey.li@linux.intel.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        "alan@linux.intel.com" <alan@linux.intel.com>,
        linux-kernel@vger.kernel.org, Len.Brown@intel.com,
        Adam Williamson <awilliam@redhat.com>
Subject: Re: [patch] x86: Introduce BOOT_EFI and BOOT_CF9 into the reboot
 sequence loop
Message-ID: <20140302022334.GA1131@srcf.ucam.org>
References: <53110977.8080907@linux.intel.com>
 <53121496.8060603@linux.intel.com>
 <20140301172256.GA29417@srcf.ucam.org>
 <53123DCF.7040500@zytor.com>
 <20140301202139.GA9759@srcf.ucam.org>
 <ec95d575-070f-4c62-8b27-3ce281cb192e@email.android.com>
 <53127AA7.8040700@linux.intel.com>
 <53127C4B.1060505@zytor.com>
 <53128DA0.9060105@linux.intel.com>
 <53129256.6060704@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53129256.6060704@zytor.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 01, 2014 at 06:07:18PM -0800, H. Peter Anvin wrote:

> We obviously have been over this a number of times, and the sad thing is
> that we have very limited information.  It is more complex than that,
> even... I believe in some cases KBD works but it is slow, and so takes a
> while.

And we still have the problem that the keyboard controller sometimes 
triggers SMM and that then hangs when it hits a piece of hardware in a 
state it doesn't expect. Sometimes reboot=b or reboot=p is just working 
around some assumptions that we could fix more convincingly.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
