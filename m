Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752071AbaAWPoM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 10:44:12 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:33694 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751499AbaAWPoK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 10:44:10 -0500
Date: Thu, 23 Jan 2014 15:09:12 +0000
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Bin Gao <bin.gao@intel.com>, x86@kernel.org
Subject: Re: [PATCH] x86, tsc: Add missing Baytrail frequency to the table
Message-ID: <20140123150912.7ee822a0@alan.etchedpixels.co.uk>
In-Reply-To: <1390475043-27457-1-git-send-email-mika.westerberg@linux.intel.com>
References: <1390475043-27457-1-git-send-email-mika.westerberg@linux.intel.com>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Jan 2014 13:04:03 +0200
Mika Westerberg <mika.westerberg@linux.intel.com> wrote:

> Baytrail is based on Silvermont core so MSR_FSB_FREQ[2:0] == 0 means that
> the CPU reference clock runs at 83.3MHz. Without this we crash a bit later
> with backtrace looking like:

Would it not be wise to also make the code robust against future failures
of this kind and at least bitch rather than divide by 0 ?

Alan
