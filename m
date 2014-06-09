Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933458AbaFILIo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 07:08:44 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:29796 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932067AbaFILIj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 07:08:39 -0400
Date: Mon, 9 Jun 2014 13:08:00 +0200
From: Daniel Kiper <daniel.kiper@oracle.com>
To: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        xen-devel@lists.xenproject.org
Cc: boris.ostrovsky@oracle.com, david.vrabel@citrix.com, hpa@zytor.com,
        jbeulich@suse.com, konrad.wilk@oracle.com, matt.fleming@intel.com,
        mingo@redhat.com, tglx@linutronix.de
Subject: Why efi_set_rtc_mmss() is never used?
Message-ID: <20140609110800.GJ15989@olila.local.net-space.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

As I can see efi_set_rtc_mmss() is never used to set RTC.
Even on EFI platform mach_set_rtc_mmss() is called and does
that thing. Why it is done in that way? It is a bug or it was
done intentionally. Am I missing something?

Daniel
