Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754856AbaFIMra (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 08:47:30 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:58271 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752662AbaFIMr1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 08:47:27 -0400
Date: Mon, 9 Jun 2014 13:46:35 +0100
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Daniel Kiper <daniel.kiper@oracle.com>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        xen-devel@lists.xenproject.org, boris.ostrovsky@oracle.com,
        david.vrabel@citrix.com, hpa@zytor.com, jbeulich@suse.com,
        konrad.wilk@oracle.com, matt.fleming@intel.com, mingo@redhat.com,
        tglx@linutronix.de
Subject: Re: Why efi_set_rtc_mmss() is never used?
Message-ID: <20140609134635.26abc019@alan.etchedpixels.co.uk>
In-Reply-To: <20140609110800.GJ15989@olila.local.net-space.pl>
References: <20140609110800.GJ15989@olila.local.net-space.pl>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Jun 2014 13:08:00 +0200
Daniel Kiper <daniel.kiper@oracle.com> wrote:

> Hi,
> 
> As I can see efi_set_rtc_mmss() is never used to set RTC.
> Even on EFI platform mach_set_rtc_mmss() is called and does
> that thing. Why it is done in that way? It is a bug or it was
> done intentionally. Am I missing something?

EFI services generally don't work properly. The less they are used the
better. We can realistically only make an EFI call with the same
parameters windows does under the same kind of circumstances because the
firmware on many motherboards is complete sh*te.

Alan
