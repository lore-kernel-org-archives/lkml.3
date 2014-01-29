Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754843AbaA2IOM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 03:14:12 -0500
Received: from mail-ob0-f171.google.com ([209.85.214.171]:46815 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752412AbaA2IOF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 03:14:05 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.02.1401282328360.10321@chino.kir.corp.google.com>
References: <1390110907-29918-1-git-send-email-sj38.park@gmail.com>
 <20140119173712.GA26481@kroah.com> <CAPtuhTikj38yKy-=uF7O+VFG_N4AWee23f9woemM318fM3V4VQ@mail.gmail.com>
 <CAEjAshoh5ucPJA6pG1sx+7HGCYjHzCKtbzmH+GYJwpefDYLwJg@mail.gmail.com>
 <CAEjAshozB4S0ZGqEn41ROfZwGTV+_GZRRTZ8cssi0VdH8Uhr_w@mail.gmail.com>
 <20140122045937.GB23869@kroah.com> <CAEjAshrxXLJ-zFsTO9TnewYBBEPzFR1cixbLnD6U-U1EKdByxg@mail.gmail.com>
 <alpine.DEB.2.02.1401282328360.10321@chino.kir.corp.google.com>
From: SeongJae Park <sj38.park@gmail.com>
Date: Wed, 29 Jan 2014 17:13:45 +0900
Message-ID: <CAEjAshoLRjZJ4M=C8H5rL8rgm8BBE2Ab2emC_xqU1YDtKfdwVQ@mail.gmail.com>
Subject: Re: [PATCH] clk: export __clk_get_hw for re-use in others
To: David Rientjes <rientjes@google.com>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Mike Turquette <mturquette@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stephen Boyd <sboyd@codeaurora.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Jan 29, 2014 at 4:29 PM, David Rientjes <rientjes@google.com> wrote:
> On Wed, 22 Jan 2014, SeongJae Park wrote:
>
>> Oops, I've forgot about the merge window. Thank you very much for your
>> kind answer.
>> Sorry if I bothered you while you're in busy time.
>> Because the build problem is not a big deal because it exists only in
>> -next tree,
>
> This problem exists in Linus's tree, not only in -next.

Yes, it looks like the problem caused commit is in Linus's tree
now(Maybe between this merge window).

But, because similar and better patch was
submitted(https://patchwork.kernel.org/patch/3507921/)
before mine by Stephen and Mike said he will merge the patch during rc1 or rc2,
looks like there is nothing we can rather than just waiting rc1 or rc2.

If there is anything I am thinking or doing wrong, please let me know.

Thanks and Regards,
SeongJae Park
