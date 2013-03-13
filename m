Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933690Ab3CMOUY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 10:20:24 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:26289 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932356Ab3CMOUU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 10:20:20 -0400
X-AuditID: cbfee691-b7f5f6d000002fda-e6-51408b23f872
From: Seungwon Jeon <tgih.jun@samsung.com>
To: "'James Hogan'" <james.hogan@imgtec.com>, linux-mmc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, "'Jaehoon Chung'" <jh80.chung@samsung.com>,
        "'Chris Ball'" <cjb@laptop.org>
References: <1363085012-9220-1-git-send-email-james.hogan@imgtec.com>
In-reply-to: <1363085012-9220-1-git-send-email-james.hogan@imgtec.com>
Subject: RE: [PATCH] mmc: dw_mmc: setpower on MMC_POWER_{UP,OFF}
Date: Wed, 13 Mar 2013 23:20:19 +0900
Message-id: <002301ce1ff5$e42f8090$ac8e81b0$%jun@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=ks_c_5601-1987
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4fDoylqjfYe24MQmaAW3BBa1SNzQA5KR2w
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrIIsWRmVeSWpSXmKPExsVy+t8zY13lbodAg9+H9Sy2v97IZvFu3gtm
	ixu/2lgtLu+aw2Zx5H8/owOrR8/OM4weh66sZfTo27KK0ePzJrkAligum5TUnMyy1CJ9uwSu
	jP1b3jIW/OKuaF3WwNjAeIGzi5GDQ0LAROJgW2EXIyeQKSZx4d56NhBbSGAZo8SFRawQcROJ
	9rO9QHEuoPh0Rompd18yQTh/GCUu3upjBqliE9CS+PvmDZgtIuAq0T95CjuIzSyQLXG8t4kZ
	YqqrxPlHB8BsTgE3ibOX7jOB2MICDhLnDs5nBLFZBFQlzs6/ygJi8wrYSrTO2cwKYQtK/Jh8
	jwVipoHE+1l9rBC2vMTmNW+ZIZ5Rl3j0VxfiBCOJp7OfQZWLSOx78Y4R5GYJgUvsEv8fTGWF
	2CUg8W3yIRaIXlmJTRCnSQhIShxccYNlAqPELCSbZyHZPAvJ5llIVixgZFnFKJpakFxQnJRe
	ZKpXnJhbXJqXrpecn7uJERKdE3cw3j9gfYgxGWj9RGYp0eR8YHTnlcQbGpsZWZiamBobmVua
	kSasJM6r3mIdKCSQnliSmp2aWpBaFF9UmpNafIiRiYNTqoHRw+lRolSpt/lxlrC628+N03ps
	dnbWnZ3G9zg6Xtnni+s1Bv2bmit+fSjR5XBI2r5OdP97N+MjasVlfBc36nmwtKY6TNvrMef/
	la3XOh/HNn/jXnvR+eDuaZO+HW0TY7E5fHJeloXapfvhGndtrzwPfBfz0bRIa2uQoZPVpCuX
	M2xeFX2ozBZSYinOSDTUYi4qTgQASQvaAuQCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrAKsWRmVeSWpSXmKPExsVy+t9jQV3lbodAg9f7tCy2v97IZvFu3gtm
	ixu/2lgtLu+aw2Zx5H8/owOrR8/OM4weh66sZfTo27KK0ePzJrkAlqgGRpuM1MSU1CKF1Lzk
	/JTMvHRbJe/geOd4UzMDQ11DSwtzJYW8xNxUWyUXnwBdt8wcoMVKCmWJOaVAoYDE4mIlfTtM
	E0JD3HQtYBojdH1DguB6jAzQQMI6xoz9W94yFvzirmhd1sDYwHiBs4uRk0NCwESi/WwvG4Qt
	JnHh3nogm4tDSGA6o8TUuy+ZIJw/jBIXb/Uxg1SxCWhJ/H3zBswWEXCV6J88hR3EZhbIljje
	2wQWFwKKn390AMzmFHCTOHvpPhOILSzgIHHu4HxGEJtFQFXi7PyrLCA2r4CtROuczawQtqDE
	j8n3WCBmGki8n9XHCmHLS2xe8xZoJgfQpeoSj/7qQpxgJPF09jOochGJfS/eMU5gFJqFZNIs
	JJNmIZk0C0nLAkaWVYyiqQXJBcVJ6bmGesWJucWleel6yfm5mxjB8f9MagfjygaLQ4wCHIxK
	PLwCX+0DhVgTy4orcw8xSnAwK4nwLs91CBTiTUmsrEotyo8vKs1JLT7EmAz06ERmKdHkfGBq
	yiuJNzQ2MTOyNDKzMDIxNydNWEmc90CrdaCQQHpiSWp2ampBahHMFiYOTqkGxpn/hSc+3201
	+YXZtLJDWSc3z/0QecpLzsTj8tJ/rH4pdyxfpYRppW9iLzL6oryldMX0tAjDgjvLcgWrLt1Y
	WijS15G7c9K5pOdFibMe7l97llks69nKlZVFjzYazbtcyPZcZf8P71vf2fjFdkedO3ZksbFT
	usI0uVdGYglLC+WuzJ0zz2vW19dKLMUZiYZazEXFiQC3oYEwQwMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi James,

On Tuesday, March 12, 2013, James Hogan wrote:
> Call the setpower platform callback in response to set_ios with
> ios->power_mode == MMC_POWER_UP or MMC_POWER_OFF, instead of from the
> card detect work function.
> 
> This appears to fix a problem I have where a card stuck in a funny state
> doesn't get properly cleared by the power being turned off, presumably
> due to lack of power sequencing. This resulted in the following log
> messages after boot:
> 
> mmc0: error -110 whilst initialising SD card
> mmc_host mmc0: Bus speed (slot 0) = 99840000Hz (slot req 300000Hz, actual 298922HZ div = 167)
> mmc0: error -110 whilst initialising SD card
> mmc_host mmc0: Bus speed (slot 0) = 99840000Hz (slot req 200000Hz, actual 199680HZ div = 250)
> mmc0: error -110 whilst initialising SD card
> mmc_host mmc0: Bus speed (slot 0) = 99840000Hz (slot req 195765Hz, actual 195764HZ div = 255)
> mmc0: error -110 whilst initialising SD card
> mmc_host mmc0: Bus speed (slot 0) = 99840000Hz (slot req 400000Hz, actual 399360HZ div = 125)
> mmc0: error -110 whilst initialising SD card
> mmc_host mmc0: Bus speed (slot 0) = 99840000Hz (slot req 300000Hz, actual 298922HZ div = 167)
> 
> Signed-off-by: James Hogan <james.hogan@imgtec.com>
> Cc: Seungwon Jeon <tgih.jun@samsung.com>

This patch is reasonable.
I just want to know though.
I guess this problem is happened when card is inserted as soon as card is removed.
If not, could you explain your situation more?

Thanks,
Seungwon Jeon

