Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752918AbaEHCvv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 22:51:51 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:47618 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751851AbaEHCvr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 22:51:47 -0400
Message-ID: <536AF13F.6000502@gmail.com>
Date: Wed, 07 May 2014 19:51:43 -0700
From: Frank Rowand <frowand.list@gmail.com>
Reply-To: frowand.list@gmail.com
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Rob Herring <robherring2@gmail.com>
CC: Grant Likely <grant.likely@linaro.org>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, "Ivan T. Ivanov" <iivanov@mm-sol.com>,
        Josh Cartwright <joshc@codeaurora.org>,
        Courtney Cavin <courtney.cavin@sonymobile.com>,
        Bjorn Andersson <bjorn@kryo.se>, Rob Herring <robh@kernel.org>
Subject: Re: [PATCH 1/4] of/selftest: add testcase for nodes with same name
 and address
References: <1399499298-8830-1-git-send-email-robherring2@gmail.com> <1399499298-8830-2-git-send-email-robherring2@gmail.com>
In-Reply-To: <1399499298-8830-2-git-send-email-robherring2@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/7/2014 2:48 PM, Rob Herring wrote:
> From: Rob Herring <robh@kernel.org>
> 
> Add a test case for nodes which have the same name and same
> non-translatable unit address.

If I apply patch 1 and 2 without applying 3 and 4 then console
warnings are printed, but from a different area of code than
the original problem reported.  This probably is not a big deal,
but I'm trying to figure out if I can modify the test to also
show the original problem.

The test case also properly reports the failure.

Once all 4 patches are applied, then the test case passes.

Thus:

   Tested-by: Frank Rowand <frank.rowand@sonymobile.com>

> 
> Signed-off-by: Rob Herring <robh@kernel.org>
> ---
>  drivers/of/selftest.c                        | 23 ++++++++++++++++++
>  drivers/of/testcase-data/testcases.dtsi      |  1 +
>  drivers/of/testcase-data/tests-platform.dtsi | 35 ++++++++++++++++++++++++++++
>  3 files changed, 59 insertions(+)
>  create mode 100644 drivers/of/testcase-data/tests-platform.dtsi
> 

< snip >

