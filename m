Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967852Ab3HINft (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 09:35:49 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:22777 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966148Ab3HINfr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 09:35:47 -0400
X-AuditID: cbfee68e-b7f276d000002279-b3-5204f0321c0d
From: Seungwon Jeon <tgih.jun@samsung.com>
To: "'Doug Anderson'" <dianders@chromium.org>, "'Chris Ball'" <cjb@laptop.org>
Cc: "'Olof Johansson'" <olof@lixom.net>,
        "'Jaehoon Chung'" <jh80.chung@samsung.com>,
        "'James Hogan'" <james.hogan@imgtec.com>,
        "'Grant Grundler'" <grundler@chromium.org>,
        "'Alim Akhtar'" <alim.akhtar@samsung.com>,
        "'Abhilash Kesavan'" <a.kesavan@samsung.com>,
        "'Tomasz Figa'" <tomasz.figa@gmail.com>, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1373470926-19314-1-git-send-email-dianders@chromium.org>
 <1375825071-20922-1-git-send-email-dianders@chromium.org>
 <1375825071-20922-4-git-send-email-dianders@chromium.org>
In-reply-to: <1375825071-20922-4-git-send-email-dianders@chromium.org>
Subject: RE: [PATCH v4 3/4] mmc: dw_mmc: Always setup the bus after
 suspend/resume
Date: Fri, 09 Aug 2013 22:35:45 +0900
Message-id: <001a01ce9505$59c28b20$0d47a160$%jun@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=ks_c_5601-1987
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac6S7VFYXAi7gls0T8+n2OoLvfQf2wB+K0Nw
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpkleLIzCtJLcpLzFFi42I5/e+Zka7RB5Ygg7M7WSwer1nMZPFg3jY2
	i+2vN7JZnF12kM3i1ZEfTBbv5r1gtrjxq43V4vKuOWwWR/73M1qcuv6ZzWLVrj+MDtwesxsu
	snjsnHWX3aNn5xlGj0NX1jJ6XDnRxOrRt2UVo8fnTXIB7FFcNimpOZllqUX6dglcGfNmXGIs
	eCpcsfzicvYGxif8XYycHBICJhLHVrWxQ9hiEhfurWfrYuTiEBJYxihxd+NqJpiiiVP2M0Ik
	FjFK7D90HqrqD6PEjQM7wdrZBLQk/r55wwxiiwh4SbzY/YAZpIhZ4AmTxLWP16Da9zJK7Hq2
	jQWkilPATWLxoQVg3cICIRJblp0Gi7MIqEpMmDaDEcTmFbCVmHF2HzuELSjxY/I9sBpmAQOJ
	97P6WCFseYnNa94CbeMAulVd4tFfXYgjjCROTJwKVSIise/FO0aId2ZySDx6mASxSkDi2+RD
	LBCtshKbDjBDlEhKHFxxg2UCo8QsJItnIVk8C8niWUg2LGBkWcUomlqQXFCclF5kpFecmFtc
	mpeul5yfu4kREv19OxhvHrA+xJgMtH4is5Rocj4weeSVxBsamxlZmJqYGhuZW5qRJqwkzqvW
	Yh0oJJCeWJKanZpakFoUX1Sak1p8iJGJg1OqgZHH5Pfs3ea/NitsmJD0+Gxnf4h75qstEzxW
	SzG362uWvGB61n7+qlXDrL9cH7as9gmc7/WtvD7y6nsF5apJZ+fdmtJkEcS4LEln7RFGtZdJ
	C5/GPFJtT9WfwbNCqEe91ubZbc4Pvr7Xy1aW7pGVXe/+RTJALTDbMcXZ4kTQdjMTVbubiz2P
	fFFiKc5INNRiLipOBADgkznRFAMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrPKsWRmVeSWpSXmKPExsVy+t9jAV3DDyxBBqu32Fg8XrOYyeLBvG1s
	Fttfb2SzOLvsIJvFqyM/mCzezXvBbHHjVxurxeVdc9gsjvzvZ7Q4df0zm8WqXX8YHbg9Zjdc
	ZPHYOesuu0fPzjOMHoeurGX0uHKiidWjb8sqRo/Pm+QC2KMaGG0yUhNTUosUUvOS81My89Jt
	lbyD453jTc0MDHUNLS3MlRTyEnNTbZVcfAJ03TJzgK5UUihLzCkFCgUkFhcr6dthmhAa4qZr
	AdMYoesbEgTXY2SABhLWMWbMm3GJseCpcMXyi8vZGxif8HcxcnJICJhITJyynxHCFpO4cG89
	WxcjF4eQwCJGif2HzkM5fxglbhzYyQ5SxSagJfH3zRtmEFtEwEvixe4HzCBFzAJPmCSufbzG
	CNGxl1Fi17NtLCBVnAJuEosPLQDrFhYIkdiy7DRYnEVAVWLCtBlgu3kFbCVmnN3HDmELSvyY
	fA+shlnAQOL9rD5WCFteYvOat0DbOIBuVZd49FcX4ggjiRMTp0KViEjse/GOcQKj0Cwkk2Yh
	mTQLyaRZSFoWMLKsYhRNLUguKE5KzzXUK07MLS7NS9dLzs/dxAhOLs+kdjCubLA4xCjAwajE
	w6u4nTlIiDWxrLgy9xCjBAezkgjv9gksQUK8KYmVValF+fFFpTmpxYcYk4EencgsJZqcD0x8
	eSXxhsYmZkaWRmYWRibm5qQJK4nzHmi1DhQSSE8sSc1OTS1ILYLZwsTBKdXAeFH4VBVzwWm3
	ODvtLEXZBw1yx+Y754fHsdg3z9mv5cX9j2HDgobGphem+/e2yvE+viD1uv1HUVm6nUS7jcK+
	E8s9OdRWy0uJdVodzjzHc2r9tpSHJV25v5dtVf6/9bFlv8ziJQy6Wmva2mZsajm84vtKleXT
	L4cVeH+Kr4xw3m97RTHLZW+BEktxRqKhFnNRcSIAF+XhIXIDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, August 07, 2013, Doug Anderson wrote:
> After suspend/resume all of the dw_mmc registers are reset to
> defaults.  We restore most of them, but specifically don't setup the
> clock registers after resume unless we've got a powered card.  Things
> still work because the core will eventually call set_ios() and we'll
> set things up.

Hmm, I didn't get the need of this call during resume.
I think set_ios is only valid where core layer calls.
Besides, important things is ios's parameters.
If suspend has finished successfully, last call of set_ios() is from mmc_power_off().
On seeing fields of 'mmc->ios' stored last, these values aren't proper in resume phase.
Please check mmc_power_off() function.
In case MMC_PM_KEEP_POWER it could be kept.

Thanks,
Seungwon Jeon
> 
> There doesn't seem to be any reason that I can see _not_ to set things
> up after resume.  Restoring this state makes the code easier to reason
> about and should help prevent bugs.  It also allows us to do a
> register dump before and after suspend/resume to confirm that we've
> set things up OK.
> 
> I examined the state of the dw_mmc instance before and after suspend
> after this patch.  I had no card inserted in an SD card slot.
> 
> Before this patch, differences were:
> * CLKDIV (0x08)
> * CLKENA (0x10)
> * TMOUT (0x14)
> * CMD (0x2C) - difference is not important
> * CLKSEL (0x9C - exynos specific)
> 
> After this patch, only TMOUT was different.  I have a separate patch
> for that.
> 
> Signed-off-by: Doug Anderson <dianders@chromium.org>
> ---
> Changes in v4: None
> Changes in v3: None
> Changes in v2: None
> 
>  drivers/mmc/host/dw_mmc.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/drivers/mmc/host/dw_mmc.c b/drivers/mmc/host/dw_mmc.c
> index 13a363c..0fa3135 100644
> --- a/drivers/mmc/host/dw_mmc.c
> +++ b/drivers/mmc/host/dw_mmc.c
> @@ -2522,9 +2522,7 @@ int dw_mci_resume(struct dw_mci *host)
>  		struct dw_mci_slot *slot = host->slot[i];
>  		if (!slot)
>  			continue;
> -		if (slot->mmc->pm_flags & MMC_PM_KEEP_POWER) {
> -			dw_mci_set_ios(slot->mmc, &slot->mmc->ios);
> -		}
> +		dw_mci_set_ios(slot->mmc, &slot->mmc->ios);
> 
>  		ret = mmc_resume_host(host->slot[i]->mmc);
>  		if (ret < 0)
> --
> 1.8.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


