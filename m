Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751849AbaFXUKK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 16:10:10 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56765 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750711AbaFXUKI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 16:10:08 -0400
Message-ID: <53A9DB10.2000602@zytor.com>
Date: Tue, 24 Jun 2014 13:09:52 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>
CC: Ingo Molnar <mingo@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
Subject: Re: [PATCH 1/2] x86,vdso: Move DISABLE_BRANCH_PROFILING into the
 vdso makefile
References: <53A9C6EB.50900@zytor.com> <cover.1403639279.git.luto@amacapital.net> <7beb5e4cc41140ace6e9a516053eb37afb49a07a.1403639279.git.luto@amacapital.net>
In-Reply-To: <7beb5e4cc41140ace6e9a516053eb37afb49a07a.1403639279.git.luto@amacapital.net>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/24/2014 12:50 PM, Andy Lutomirski wrote:
> It should really apply to everything in the vdso, and putting it in
> the C files seems unreliable.

Please write a more detailed patch description.  In this case, it was
causing build failures, and that should be noted in the description.

> It was missing from the list of inappropriate dynamic entries.

Same here -- what kind of problems does this cause or indicate?

	-hpa


