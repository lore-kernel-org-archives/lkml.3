Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752476Ab3BTV7b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 16:59:31 -0500
Received: from terminus.zytor.com ([198.137.202.10]:58977 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751565Ab3BTV7a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 16:59:30 -0500
Message-ID: <512546EE.2030908@zytor.com>
Date: Wed, 20 Feb 2013 13:58:06 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Alessandro Rubini <rubini@gnudd.com>
CC: linux-kernel@vger.kernel.org, Giancarlo Asnaghi <giancarlo.asnaghi@st.com>,
        Davide Ciminaghi <ciminaghi@gnudd.com>, tglx@linutronix.de,
        mingo@redhat.com, x86@kernel.org
Subject: Re: [PATCH V5 0/5] x86: a bridge from PCI to AMBA
References: <cover.1361393832.git.rubini@gnudd.com>
In-Reply-To: <cover.1361393832.git.rubini@gnudd.com>
X-Enigmail-Version: 1.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/20/2013 01:22 PM, Alessandro Rubini wrote:
> This is a repost of patches I sent quite some time ago and are
> available from the "tip" repository, as branch "x86/amba" based on
> v3.7.  That branch includes 7 patches but two of them are already
> upstream. Some of the other 5 had minor conflicts during rebase, but
> only in the initial "#include" area.
> 
> I repost as Peter Anvin suggested. The commits in the tip
> repository included both hpa's signed off (which I left in)
> and the reference to the previous lkml message, which I removed
> as it is not current by the time  this message exists.
> 
> Some acked-by we received on the mailing list are not in the patch set
> because they are missing from tip::x86/amba which is authoritative.
> 

Actually, no, they *should* be included.  The only reason they wouldn't
be in tip:x86/amba was that they weren't received by the time they got
put in the branch.

Could you add them back in?

	-hpa



