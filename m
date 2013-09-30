Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752546Ab3I3G2x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 02:28:53 -0400
Received: from mail-ee0-f45.google.com ([74.125.83.45]:53257 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751051Ab3I3G2w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 02:28:52 -0400
Date: Mon, 30 Sep 2013 08:28:48 +0200
From: Ingo Molnar <mingo@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Borislav Petkov <bp@alien8.de>, linux-kernel@vger.kernel.org,
        huawei.libin@huawei.com, wangyijing@huawei.com, fenghua.yu@intel.com,
        tglx@linutronix.de, guohanjun@huawei.com, paul.gortmaker@windriver.com,
        linux-tip-commits@vger.kernel.org
Subject: Re: [PATCH -v1.1] x86, boot: Further compress CPUs bootup message
Message-ID: <20130930062848.GB13482@gmail.com>
References: <20130928191500.GG5956@pd.tnic>
 <20130928192545.GB8228@gmail.com>
 <fc8a60d5-a876-4fe5-836f-cd778617003e@email.android.com>
 <20130928194927.GI5956@pd.tnic>
 <20130928195448.GJ5956@pd.tnic>
 <20130928195833.GB32081@gmail.com>
 <20130928200838.GK5956@pd.tnic>
 <6c689698-aaa0-48cc-8e6e-93d9059c0c34@email.android.com>
 <20130929091453.GA5426@pd.tnic>
 <a4c8ed48-24c3-437e-9f06-e42a8b7a80f4@email.android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a4c8ed48-24c3-437e-9f06-e42a8b7a80f4@email.android.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* H. Peter Anvin <hpa@zytor.com> wrote:

> If the goal is to feed this to the field width in printf, which I would 
> think would be the dominant use, then you do have to account for the 
> minus sign.

The input here is always a nonzero positive integer.

Anyway, I have no objections against using the more generic library 
function either.

Thanks,

	Ingo
