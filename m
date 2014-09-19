Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757856AbaISXDt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 19:03:49 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57117 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756626AbaISXDs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 19:03:48 -0400
Date: Fri, 19 Sep 2014 16:03:47 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Stanimir Varbanov <svarbanov@mm-sol.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>, rtc-linux@googlegroups.com,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        Stephen Boyd <sboyd@codeaurora.org>,
        Josh Cartwright <joshc@codeaurora.org>
Subject: Re: [PATCH] rtc: pm8xxx: rework to support pm8941 rtc
Message-Id: <20140919160347.eaa72f4b715338e4210790df@linux-foundation.org>
In-Reply-To: <1410515044-31689-1-git-send-email-svarbanov@mm-sol.com>
References: <1410515044-31689-1-git-send-email-svarbanov@mm-sol.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Sep 2014 12:44:04 +0300 Stanimir Varbanov <svarbanov@mm-sol.com> wrote:

> Adds support for RTC device inside PM8941 PMIC. The RTC
> in this PMIC have two register spaces. Thus the rtc-pm8xxx
> is slightly reworked to reflect these differences.
> 
> The register set for different PMIC chips are selected
> on DT compatible string base.

checkpatch (which you obviously didn't use!) says

WARNING: DT compatible string "qcom,pm8941-rtc" appears un-documented -- check ./Documentation/devicetree/bindings/
#414: FILE: drivers/rtc/rtc-pm8xxx.c:435:
+       { .compatible = "qcom,pm8941-rtc", .data = &pm8941_regs },
