Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752812AbaFBWnF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 18:43:05 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:42784 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752738AbaFBWnD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 18:43:03 -0400
Date: Mon, 2 Jun 2014 15:43:02 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Tony Luck <tony.luck@intel.com>, Andi Kleen <andi@firstfloor.org>,
        Kamil Iskra <iskra@mcs.anl.gov>, Borislav Petkov <bp@suse.de>,
        Chen Gong <gong.chen@linux.jf.intel.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH 0/3] HWPOISON: improve memory error handling for
 multithread process
Message-Id: <20140602154302.595a54190afdffd4b50f22c2@linux-foundation.org>
In-Reply-To: <5388cd0e.463edd0a.755d.6f61SMTPIN_ADDED_BROKEN@mx.google.com>
References: <53877e9c.8b2cdc0a.1604.ffffea43SMTPIN_ADDED_BROKEN@mx.google.com>
	<1401432670-24664-1-git-send-email-n-horiguchi@ah.jp.nec.com>
	<3908561D78D1C84285E8C5FCA982C28F32823225@ORSMSX114.amr.corp.intel.com>
	<5388cd0e.463edd0a.755d.6f61SMTPIN_ADDED_BROKEN@mx.google.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 May 2014 14:24:52 -0400 Naoya Horiguchi <n-horiguchi@ah.jp.nec.com> wrote:

> On Fri, May 30, 2014 at 05:25:39PM +0000, Luck, Tony wrote:
> > > This patchset is the summary of recent discussion about memory error handling
> > > on multithread application. Patch 1 and 2 is for action required errors, and
> > > patch 3 is for action optional errors.
> > 
> > Naoya,
> > 
> > You suggested early in the discussion (when there were just two patches) that
> > they deserved a "Cc: stable@vger.kernel.org".  I agreed, and still think the same
> > way.
> 
> Correct. AR error handling was added in v3.2-rc5, so adding
> "Cc: stable@vger.kernel.org # v3.2+" is fine.

I'm not sure that "[PATCH 3/3] mm/memory-failure.c: support dedicated
thread to handle SIGBUS(BUS_MCEERR_AO)" is a -stable thing?  That's a
feature addition more than a bugfix?

