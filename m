Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753536AbaEHJAR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 05:00:17 -0400
Received: from mail-ie0-f175.google.com ([209.85.223.175]:35073 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752769AbaEHJAO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 05:00:14 -0400
MIME-Version: 1.0
In-Reply-To: <536AF13F.6000502@gmail.com>
References: <1399499298-8830-1-git-send-email-robherring2@gmail.com>
 <1399499298-8830-2-git-send-email-robherring2@gmail.com> <536AF13F.6000502@gmail.com>
From: Grant Likely <grant.likely@linaro.org>
Date: Thu, 8 May 2014 09:59:53 +0100
X-Google-Sender-Auth: cDHygtnay4gBp94PRCx3gwcHzS4
Message-ID: <CACxGe6seW1MYC5iqZriXzrR1_hcR_DfLs5exUCLEZY3CRb28pw@mail.gmail.com>
Subject: Re: [PATCH 1/4] of/selftest: add testcase for nodes with same name
 and address
To: Frank Rowand <frowand.list@gmail.com>
Cc: Rob Herring <robherring2@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "Ivan T. Ivanov" <iivanov@mm-sol.com>,
        Josh Cartwright <joshc@codeaurora.org>,
        Courtney Cavin <courtney.cavin@sonymobile.com>,
        Bjorn Andersson <bjorn@kryo.se>, Rob Herring <robh@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 8, 2014 at 3:51 AM, Frank Rowand <frowand.list@gmail.com> wrote:
> On 5/7/2014 2:48 PM, Rob Herring wrote:
>> From: Rob Herring <robh@kernel.org>
>>
>> Add a test case for nodes which have the same name and same
>> non-translatable unit address.
>
> If I apply patch 1 and 2 without applying 3 and 4 then console
> warnings are printed, but from a different area of code than
> the original problem reported.  This probably is not a big deal,
> but I'm trying to figure out if I can modify the test to also
> show the original problem.
>
> The test case also properly reports the failure.
>
> Once all 4 patches are applied, then the test case passes.

When adding testcases I do prefer the addition of the test to appear
before the fix while the patch is under review. Makes it easy to see
that, yes the bug exists, and yes the later patch resolves it.

When the patches are actually committed for merging then it is
probably a good idea to reverse them. Thanks for the testing.

g.

>
> Thus:
>
>    Tested-by: Frank Rowand <frank.rowand@sonymobile.com>
>
>>
>> Signed-off-by: Rob Herring <robh@kernel.org>
>> ---
>>  drivers/of/selftest.c                        | 23 ++++++++++++++++++
>>  drivers/of/testcase-data/testcases.dtsi      |  1 +
>>  drivers/of/testcase-data/tests-platform.dtsi | 35 ++++++++++++++++++++++++++++
>>  3 files changed, 59 insertions(+)
>>  create mode 100644 drivers/of/testcase-data/tests-platform.dtsi
>>
>
> < snip >
>
