Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754523AbbAGS27 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 13:28:59 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:56872 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754349AbbAGS24 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 13:28:56 -0500
Date: Wed, 7 Jan 2015 10:28:55 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: John Stultz <john.stultz@linaro.org>
Cc: lkml <linux-kernel@vger.kernel.org>, Sasha Levin <sasha.levin@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        stable <stable@vger.kernel.org>, Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH 2/2] time: adjtimex: Validate the ADJ_FREQUENCY values
Message-ID: <20150107182855.GB7699@kroah.com>
References: <1420654340-3009-1-git-send-email-john.stultz@linaro.org>
 <1420654340-3009-3-git-send-email-john.stultz@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1420654340-3009-3-git-send-email-john.stultz@linaro.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 07, 2015 at 10:12:20AM -0800, John Stultz wrote:
> From: Sasha Levin <sasha.levin@oracle.com>
> 
> Verify that the frequency value from userspace is valid and makes sense.
> 
> Unverified values can cause overflows later on.
> 
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: stable <stable@vger.kernel.org>
> Cc: Andy Lutomirski <luto@amacapital.net>
> Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
> [jstultz: Fix up bug for negative values and drop redunent cap check]
> Signed-off-by: John Stultz <john.stultz@linaro.org>
> ---
>  kernel/time/ntp.c | 7 +++++++
>  1 file changed, 7 insertions(+)

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read Documentation/stable_kernel_rules.txt
for how to do this properly.

</formletter>
