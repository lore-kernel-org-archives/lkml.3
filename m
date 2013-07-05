Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752103Ab3GEWtZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 18:49:25 -0400
Received: from mailout3.w2.samsung.com ([211.189.100.13]:37364 "EHLO
	usmailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751019Ab3GEWtY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 18:49:24 -0400
X-AuditID: cbfec37d-b7f036d000004805-d4-51d74d723f6d
From: Shuah Khan <shuah.kh@samsung.com>
To: Shuah Khan <shuah.kh@samsung.com>
Cc: "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "shuahkhan@gmail.com" <shuahkhan@gmail.com>,
        Shuah Khan <shuah.kh@samsung.com>
Subject: Re: [PATCH] arm: Convert sa1111 platform and bus legacy pm_ops to
 dev_pm_ops
Thread-topic: [PATCH] arm: Convert sa1111 platform and bus legacy pm_ops to
 dev_pm_ops
Thread-index: AQHOedFX+6nUjqQH7EeziryaTTIsRA==
Date: Fri, 05 Jul 2013 22:49:21 +0000
Message-id: <B8EFE96D1287C24090BAD9D858E15E617360A6@sisaex02sj>
References: <1373064297-13582-1-git-send-email-shuah.kh@samsung.com>
Accept-Language: en-US
Content-language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
X-Originating-IP: [105.144.21.63]
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 8BIT
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpnkeLIzCtJLcpLzFFi42I5/e+wr26x7/VAg5P7mSyaF69ns9j0+Bqr
	xeVdc9gsbl/mtfj608GB1aOluYfNY+esu+we++euYffYvKTe4/MmuQDWKC6blNSczLLUIn27
	BK6MlsWz2QpucVacv3KfuYGxg6OLkZNDQsBE4uHyJawQtpjEhXvr2boYuTiEBJYxSvxqXcsI
	4fQySaxZsJAFwpnPKNE5azVYC5uAusTn1zvYQWwRAVWJlquPwdqZBa4xScw9MwssISwQLrH7
	x0QWiKIIiY3/7jBB2HoS35sXMIPYLEDNDbsWg9XzCthLvNu0ESwuJOAiMWX6FDCbEei+76fW
	gPUyC4hLNLfeZIG4W0BiyZ7zzBC2qMTLx/+AjuMAshUltq+2gijXkli/8zhUq7bEk3cXWCFW
	CUr8mHyPZQKj2CwkU2chaZmFpGUWkpYFjCyrGMVKi5MLipPSUytM9IoTc4tL89L1kvNzNzFC
	Iq92B+P9rzaHGAU4GJV4eBMvXgsUYk0sK67MPcQowcGsJMJrnwAU4k1JrKxKLcqPLyrNSS0+
	xMjEwSnVwHhN0dBTxeFC+j0PdeHE2+xfEoS3faqMXrX0w9Mjn24tP/lh+ZvNncb2kt8OlPB2
	NTOtbf1tmar0cb+x3zqV5hdrojZnrez0WaWU/WqSxwPlU22nvAOOnljoZHHARm6S99oPTnyN
	+Y8O5JbNf1Nem5D4yX6qHhOXRLrkkbz/Lqx7JCckHZ6RFa7EUpyRaKjFXFScCAA2VTW4mgIA	AA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/05/2013 04:45 PM, Shuah Khan wrote:
> Convert arch/arm/common/sa1111 platform and bus legacy pm_ops to dev_pm_ops.
> This change also updates the use of COMFIG_PM to CONFIG_PM_SLEEP as this
> platform and bus code implements PM_SLEEP ops and not the PM_RUNTIME ops.
> Compile tested.
>
> Signed-off-by: Shuah Khan <shuah.kh@samsung.com>
> ---
>   arch/arm/common/sa1111.c |    2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/arm/common/sa1111.c b/arch/arm/common/sa1111.c
> index 2a64c12..95594f0 100644
> --- a/arch/arm/common/sa1111.c
> +++ b/arch/arm/common/sa1111.c
> @@ -1321,7 +1321,7 @@ static int sa1111_bus_resume(struct device *dev)
>   }
>   static SIMPLE_DEV_PM_OPS(sa1111_bus_dev_pm_ops, sa1111_bus_suspend,
>   			 sa1111_bus_resume);
> -#endif
> +#endif
>
>   static void sa1111_bus_shutdown(struct device *dev)
>   {
>

Please ignore this patch - it is not correct.

-- Shuah

-- 
Shuah Khan, Linux Kernel Developer - Open Source Group Samsung Research 
America (Silicon Valley) shuah.kh@samsung.com | (970) 672-0658
