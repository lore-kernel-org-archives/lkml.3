Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752727AbaBXN3p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 08:29:45 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:39369 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752260AbaBXN3n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 08:29:43 -0500
Date: Mon, 24 Feb 2014 13:29:16 +0000
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "David E. Box" <david.e.box@linux.intel.com>, tglx@linutronix.de,
        mingo@redhat.com, x86@kernel.org, linux-kernel@vger.kernel.org,
        srinivas.pandruvada@linux.intel.com, jacob.jun.pan@intel.com
Subject: Re: [PATCH RESEND] x86: iosf_mbi: Provide dummy functions if
 CONFIG_IOSF_MBI not set
Message-ID: <20140224132916.69b95bf5@alan.etchedpixels.co.uk>
In-Reply-To: <530B4767.9010109@zytor.com>
References: <1392248063-16389-1-git-send-email-david.e.box@linux.intel.com>
	<1393117352-23717-1-git-send-email-david.e.box@linux.intel.com>
	<20140224131902.30983051@alan.etchedpixels.co.uk>
	<530B4767.9010109@zytor.com>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Feb 2014 05:21:43 -0800
"H. Peter Anvin" <hpa@zytor.com> wrote:

> On 02/24/2014 05:19 AM, One Thousand Gnomes wrote:
> >
> > Other than _available I would have expected all the others to resolve to
> > returning an error or doing a WARN() in the not compiled in case.
> >
> 
> WARN() or BUG()?

WARN I think. The usage cases I am aware of don't end up in catastrophic
failure if you get this wrong, but would be annoying to debug if missed.

Alan
