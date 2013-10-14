Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757822Ab3JNVDX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 17:03:23 -0400
Received: from mail-we0-f181.google.com ([74.125.82.181]:39459 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932221Ab3JNVDS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 17:03:18 -0400
MIME-Version: 1.0
In-Reply-To: <20131014184717.GK4009@pd.tnic>
References: <1381473166-29303-1-git-send-email-gong.chen@linux.intel.com>
	<1381473166-29303-8-git-send-email-gong.chen@linux.intel.com>
	<20131011160208.GL5925@pd.tnic>
	<20131014045500.GC12189@gchen.bj.intel.com>
	<20131014103616.GE4009@pd.tnic>
	<CA+8MBbJ9P1GVf3SCh7LMY_LH+pxQg3GWkxKMzni1b1Wyx1o8NQ@mail.gmail.com>
	<20131014184717.GK4009@pd.tnic>
Date: Mon, 14 Oct 2013 14:03:16 -0700
Message-ID: <CA+8MBbKDhFvRmJv1csMp5At8WfvHvSsDBbCKvOfQhVdgmnwBWg@mail.gmail.com>
Subject: Re: [PATCH 7/8] ACPI, APEI, CPER: Cleanup CPER memory error output format
From: Tony Luck <tony.luck@gmail.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Chen Gong <gong.chen@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-acpi <linux-acpi@vger.kernel.org>,
        Lance Ortiz <lance.ortiz@hp.com>,
        "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 14, 2013 at 11:47 AM, Borislav Petkov <bp@alien8.de> wrote:
> It is basically the same idea as with the ras daemon - if we have a
> userspace consumer of ras trace events, we disable dmesg output. So the
> decision will be left to the userspace tool to disable dmesg output as a
> last step of its initialization.

Do you have a suggested mechanism for this disabling of dmesg?

-Tony
