Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757323AbaCSHuQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 03:50:16 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:62229 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757041AbaCSHuO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 03:50:14 -0400
X-AuditID: cbfec7f4-b7f796d000005a13-0c-53294c331fae
Message-id: <1395215408.18730.2.camel@AMDC1943>
Subject: Re: [PATCH v3 1/3] clk: s2mps11: Add support for S2MPS14 clocks
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Mike Turquette <mturquette@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, Sangbeom Kim <sbkim73@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        Tushar Behera <tushar.behera@linaro.org>,
        Yadwinder Singh Brar <yadi.brar@samsung.com>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>
Date: Wed, 19 Mar 2014 08:50:08 +0100
In-reply-to: <20140319001643.30995.46947@quantum>
References: <1395047958-17953-1-git-send-email-k.kozlowski@samsung.com>
 <1395047958-17953-2-git-send-email-k.kozlowski@samsung.com>
 <20140319001643.30995.46947@quantum>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.2.3-0ubuntu6
Content-transfer-encoding: 7bit
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrHLMWRmVeSWpSXmKPExsVy+t/xq7rGPprBBtN261lsnLGe1eJs0xt2
	i/tfjzJabHp8jdXi8q45bBYzzu9jslh75C67xdMJF9ksTv7pZbQ43c1qcXHFFyaL9TNes1i0
	/93LZjFn+jsmBz6PO9f2sHnMOxnosXlJvUffllWMHp83yQWwRnHZpKTmZJalFunbJXBlLL+d
	UHCXvWLXE6UGxsVsXYycHBICJhJT/rSxQ9hiEhfurQeKc3EICSxllLg0YyYjhPOZUWLamj+M
	IFW8AvoSvZcegNnCAh4SM2b/AOtmEzCW2Lx8CdhUEQEtiW0HWsEmMQtMZ5FY8GklWBGLgKrE
	ocmvmUBsTgFDiRsnrjJBbFjDKHGo7SIzSIJZQF1i0rxFzBA3KUnsbu9kh4jLS2xe85YZ4gpB
	iR+T77FMYBSYhaRlFpKyWUjKFjAyr2IUTS1NLihOSs811CtOzC0uzUvXS87P3cQIiZMvOxgX
	H7M6xCjAwajEwysZqxEsxJpYVlyZe4hRgoNZSYRX+C5QiDclsbIqtSg/vqg0J7X4ECMTB6dU
	A6Nu4pyZEhk+4t1d3NOvCr7eY/Nibvsuq8Npj0TmdrPEt+57v1qVv3ZS70rfnbHLPraUbmUz
	D8iJWnbg6Jv5c6ffSbO37IlcnWnT9/F3zPr2T9f3nuFOOaP1znfmcruVDzpOfjv66YeL4A6R
	szZM95dekT8c1pQZY9joZjF9scgnKQNNIfHV962UWIozEg21mIuKEwFkDaK+cQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-03-18 at 17:16 -0700, Mike Turquette wrote:
> Quoting Krzysztof Kozlowski (2014-03-17 02:19:16)
> > This patch adds support for S2MPS14 PMIC clocks (BT and AP) to the
> > s2mps11 clock driver.
> > 
> > Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> > Reviewed-by: Yadwinder Singh Brar <yadi.brar@samsung.com>
> > Reviewed-by: Tomasz Figa <t.figa@samsung.com>
> 
> This does not apply cleanly to to clk tree trip, nor does it compile
> after manually merging due to changes introducing
> linux/mfd/samsung/s2mps14.h.
> 
> The changes look OK to me so maybe Lee can take it with my Ack?
> 
> Acked-by: Mike Turquette <mturquette@linaro.org>
> 

Hi,

Thanks for the Ack. The patch depends on Tushar Behera's patches:
 - [PATCH V2 0/2] Add support for clocks in S5M8767
   http://thread.gmane.org/gmane.linux.kernel.samsung-soc/27264
which are waiting for some time. Both patchsets should be pulled
together.

Best regards,
Krzysztof

