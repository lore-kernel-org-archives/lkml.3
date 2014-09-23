Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754797AbaIWJCH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 05:02:07 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:47675 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752908AbaIWJCE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 05:02:04 -0400
Message-ID: <54213708.7050605@mm-sol.com>
Date: Tue, 23 Sep 2014 12:02:00 +0300
From: Stanimir Varbanov <svarbanov@mm-sol.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Alessandro Zummo <a.zummo@towertech.it>, rtc-linux@googlegroups.com,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        Stephen Boyd <sboyd@codeaurora.org>,
        Josh Cartwright <joshc@codeaurora.org>
Subject: Re: [PATCH] rtc: pm8xxx: rework to support pm8941 rtc
References: <1410515044-31689-1-git-send-email-svarbanov@mm-sol.com> <20140919160347.eaa72f4b715338e4210790df@linux-foundation.org>
In-Reply-To: <20140919160347.eaa72f4b715338e4210790df@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/20/2014 02:03 AM, Andrew Morton wrote:
> On Fri, 12 Sep 2014 12:44:04 +0300 Stanimir Varbanov <svarbanov@mm-sol.com> wrote:
> 
>> Adds support for RTC device inside PM8941 PMIC. The RTC
>> in this PMIC have two register spaces. Thus the rtc-pm8xxx
>> is slightly reworked to reflect these differences.
>>
>> The register set for different PMIC chips are selected
>> on DT compatible string base.
> 
> checkpatch (which you obviously didn't use!) says
> 
> WARNING: DT compatible string "qcom,pm8941-rtc" appears un-documented -- check ./Documentation/devicetree/bindings/
> #414: FILE: drivers/rtc/rtc-pm8xxx.c:435:
> +       { .compatible = "qcom,pm8941-rtc", .data = &pm8941_regs },

Ahh, sorry for inconvenience I forgot to run checkpatch over this patch.

I will send follow-up patch which will add the compatible string in the
pm8xxx binding document.

-- 
regards,
Stan
