Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752541AbbAMLXc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 06:23:32 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:27800 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751283AbbAMLXa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 06:23:30 -0500
X-AuditID: cbfec7f4-b7f126d000001e9a-d1-54b50030b3f0
Message-id: <54B5002F.9030004@samsung.com>
Date: Tue, 13 Jan 2015 12:23:27 +0100
From: Marek Szyprowski <m.szyprowski@samsung.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101
 Thunderbird/31.3.0
MIME-version: 1.0
To: Rob Herring <robherring2@gmail.com>,
        "George G. Davis" <ggdavisiv@gmail.com>
Cc: "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        "George G. Davis" <george_davis@mentor.com>
Subject: Re: [PATCH] drivers: of: Export of_reserved_mem_device_{init,release}
References: <1420813745-130341-1-git-send-email-george_davis@mentor.com>
 <CAL_JsqJaT-Y7DHQS5ZZ0TP6r0iPDbUZwU-Kec5MSE7DOPgZxCg@mail.gmail.com>
In-reply-to: <CAL_JsqJaT-Y7DHQS5ZZ0TP6r0iPDbUZwU-Kec5MSE7DOPgZxCg@mail.gmail.com>
Content-type: text/plain; charset=utf-8; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrPLMWRmVeSWpSXmKPExsVy+t/xy7oGDFtDDP6sNbWYf+Qcq8WT/99Z
	LVbve8dmceDPDkaLy7vmsFm07j3CbvH92zc2B3aPnbPusntsWtXJ5nHn2h42j91fmxg9Pm+S
	C2CN4rJJSc3JLEst0rdL4Mr4NX8OU8F5tor1zxUaGFeydjFyckgImEisOzObGcIWk7hwbz1b
	FyMXh5DAUkaJrzcbWCGcT4wSN3oesIFU8QpoSVy+dpkdxGYRUJV41PAXbBKbgKFE19susBpR
	gRiJxQtXM0PUC0r8mHyPBcQWEQiQOPX4B9hQZoGfjBKX16wFaxYW8JOY1rCSEWJbP6PEqps3
	wTZwCgRLHDp3BWwSs4CZxJeXh1khbHmJzWveMk9gFJiFZMksJGWzkJQtYGRexSiaWppcUJyU
	nmuoV5yYW1yal66XnJ+7iRES6F92MC4+ZnWIUYCDUYmHd0f2lhAh1sSy4srcQ4wSHMxKIrzp
	34FCvCmJlVWpRfnxRaU5qcWHGJk4OKUaGAUf3nr1fMcWkZ3veaPnxBwv5Fn+i1NNs0b4xht9
	wTCdpXuvzvf6q9el7Pgj+L/htrBrHKxzEgzePZ0slvigv1fw1Yq/wTsENu1sa4ntaTc7zHbu
	8dX/v17sn3SsROTfFp2CtSpbo/ausVefeehEVVjTJMFaz5ve2n9mHr93NnyHIGeBiVVMQ5US
	S3FGoqEWc1FxIgA/BlFLUgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 2015-01-09 18:53, Rob Herring wrote:
> On Fri, Jan 9, 2015 at 8:29 AM, George G. Davis <ggdavisiv@gmail.com> wrote:
>> Export of_reserved_mem_device_{init,release} so that modules
>> can initialize and release their assigned per-device cma_area.
> I believe the original intent was for the core bus code to call these
> functions. While the commit adding them says "automated assignment"
> that part did not go in. As it stands, there are no in tree users of
> these functions.
>
> Marek, comments?

Yes, my idea was to call it directly from platform bus code, but Grant
opposed, so right now the drivers need to do it on their own. Assuming
that those functions need to be called from drivers, then EXPORT_SYMPOL_GPL
is the correct approach.

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland

