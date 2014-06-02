Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752767AbaFBIPk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 04:15:40 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:38438 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751708AbaFBIPh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 04:15:37 -0400
Message-ID: <538C329C.8060009@mm-sol.com>
Date: Mon, 02 Jun 2014 11:15:24 +0300
From: Stanimir Varbanov <svarbanov@mm-sol.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Bjorn Andersson <bjorn@kryo.se>
CC: Kumar Gala <galak@codeaurora.org>,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Josh Cartwright <joshc@codeaurora.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>
Subject: Re: [PATCH 0/3] Qualcomm Resource Power Manager driver
References: <1401211721-19712-1-git-send-email-bjorn.andersson@sonymobile.com> <F773CDFB-2957-49C0-99D3-E9CDCE33C378@codeaurora.org> <CAJAp7Ojb7PvuNYJkPyKx+iehi0bF6rdYvYmfrDz21mebxMN1qg@mail.gmail.com>
In-Reply-To: <CAJAp7Ojb7PvuNYJkPyKx+iehi0bF6rdYvYmfrDz21mebxMN1qg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bjorn,

Thanks for the patches.

<snip>

> Lately I've been working on rpm, rpm-smd, smem, smd, smsm, smp2p
> patches for mainline.
> It could be argued that smd is a bus and should go in drivers/bus, but
> for the rest I fear that we just created drivers/soc/qcom as another
> dumping ground for things; a "Qualcomm specific drivers/mfd".

Do we have some obstacles to not use a "common mailbox framework" for
this IPC (shared memory) communication. It looks that it fits very well
with our needs for this rpm-regulator and future submitting of smd driver?

-- 
regards,
Stan
