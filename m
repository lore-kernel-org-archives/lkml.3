Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754185AbaIHTKD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 15:10:03 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59078 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753963AbaIHTKB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 15:10:01 -0400
Message-ID: <540DFED8.5080909@zytor.com>
Date: Mon, 08 Sep 2014 12:09:12 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>, Fenghua Yu <fenghua.yu@intel.com>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        linux-kernel <linux-kernel@vger.kernel.org>, x86 <x86@kernel.org>
Subject: Re: [PATCH] x86/microcode: add parameter dis_ucode_ldr in kernel-paramenters.txt
References: <1409857626-55464-1-git-send-email-fenghua.yu@intel.com> <20140905085709.GC11432@nazgul.tnic>
In-Reply-To: <20140905085709.GC11432@nazgul.tnic>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/05/2014 01:57 AM, Borislav Petkov wrote:
> 
>> This patch adds the explanation for this parameter in
>> Documentation/kernel-parameters.txt for user convenience.
> 
> As I said earlier, I don't want to do exactly that because this
> parameter should be used only to rule out microcode loading causes a
> problem and not regularly. I know, it doesn't stop people from looking
> at the code but still.
> 

Are you genuinely saying we shouldn't document this command line
parameter?  Sorry, it really doesn't work that way.

	-hpa


