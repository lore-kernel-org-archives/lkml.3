Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751741Ab3KSHWp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 02:22:45 -0500
Received: from mail-ee0-f42.google.com ([74.125.83.42]:46745 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751002Ab3KSHWo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 02:22:44 -0500
Date: Tue, 19 Nov 2013 08:22:41 +0100
From: Ingo Molnar <mingo@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Johannes =?iso-8859-1?Q?L=F6thberg?= <johannes@kyriasis.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: boot: Fix mixed indentation in a20.c
Message-ID: <20131119072241.GB32478@gmail.com>
References: <1384797009-4096-1-git-send-email-johannes@kyriasis.com>
 <528ACB6A.1040809@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <528ACB6A.1040809@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* H. Peter Anvin <hpa@zytor.com> wrote:

> On 11/18/2013 09:50 AM, Johannes Löthberg wrote:
> > Replace all mixed indentation with tabs
> > 
> > Signed-off-by: Johannes Löthberg <johannes@kyriasis.com>
> 
> NAK.  Not worth the churn in the absence of other changes.

Yes.

If a20.c was cleaned up altogether, that might be a more tempting 
change, it has a good number of inconsistencies and improving it all 
would make it more readable.
 
But it makes little sense to do an incomplete cleanup.

Thanks,

	Ingo
