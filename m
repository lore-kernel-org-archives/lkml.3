Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752482Ab3JAIxR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 04:53:17 -0400
Received: from mail-ee0-f49.google.com ([74.125.83.49]:56480 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751790Ab3JAIxP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 04:53:15 -0400
Date: Tue, 1 Oct 2013 10:53:10 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Borislav Petkov <bp@alien8.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        huawei.libin@huawei.com, wangyijing@huawei.com, fenghua.yu@intel.com,
        tglx@linutronix.de, guohanjun@huawei.com, paul.gortmaker@windriver.com,
        linux-tip-commits@vger.kernel.org
Subject: Re: [PATCH -v1.1] x86, boot: Further compress CPUs bootup message
Message-ID: <20131001085310.GA22525@gmail.com>
References: <fc8a60d5-a876-4fe5-836f-cd778617003e@email.android.com>
 <20130928194927.GI5956@pd.tnic>
 <20130928195448.GJ5956@pd.tnic>
 <20130928195833.GB32081@gmail.com>
 <20130928200838.GK5956@pd.tnic>
 <6c689698-aaa0-48cc-8e6e-93d9059c0c34@email.android.com>
 <20130929091453.GA5426@pd.tnic>
 <a4c8ed48-24c3-437e-9f06-e42a8b7a80f4@email.android.com>
 <20130930062848.GB13482@gmail.com>
 <20130930095624.GB16383@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130930095624.GB16383@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Borislav Petkov <bp@alien8.de> wrote:

> On Mon, Sep 30, 2013 at 08:28:48AM +0200, Ingo Molnar wrote:
> > * H. Peter Anvin <hpa@zytor.com> wrote:
> > 
> > > If the goal is to feed this to the field width in printf, which I would 
> > > think would be the dominant use, then you do have to account for the 
> > > minus sign.
> > 
> > The input here is always a nonzero positive integer.
> > 
> > Anyway, I have no objections against using the more generic library 
> > function either.
> 
> Ok, let's do it this way - if someone wants to change it later, she can
> split/carve/write anew/whatever it... I don't care anymore.
> 
> :-)

Looks perfect to me!

Thanks,

	Ingo
