Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754477Ab3FELZ3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 07:25:29 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:15268 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752862Ab3FELZ1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 07:25:27 -0400
X-AuditID: cbfee690-b7f6f6d00000740c-58-51af202578a5
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Vikas Sajjan'" <sajjan.linux@gmail.com>,
        "'Jingoo Han'" <jg1.han@samsung.com>
Cc: linux-samsung-soc@vger.kernel.org,
        "'Thomas Abraham'" <thomas.abraham@linaro.org>,
        "'Olof Johansson'" <olof@lixom.net>,
        "'Doug Anderson'" <dianders@chromium.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        "'sunil joshi'" <joshi@samsung.com>
References: <003001ce4e1b$24a28fc0$6de7af40$@samsung.com>
 <CAGm_ybh_Uvs2dX3Ecgcwy=GFO6QH-Hj1jz3f1=cDbZGq0Q4qDQ@mail.gmail.com>
In-reply-to: <CAGm_ybh_Uvs2dX3Ecgcwy=GFO6QH-Hj1jz3f1=cDbZGq0Q4qDQ@mail.gmail.com>
Subject: RE: [PATCH 1/2] ARM: dts: add DP clock reference to exynos5250 device
 tree
Date: Wed, 05 Jun 2013 20:25:25 +0900
Message-id: <08da01ce61df$6013ba70$203b2f50$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 8BIT
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac5O4xglWys+Pd07QOiIlvjaizEYfAS+2dew
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrGIsWRmVeSWpSXmKPExsVy+t8zQ11VhfWBBjNfmFmcXXaQzeLywkus
	Ft93fWG32PT4GqvF5V1z2CxmnN/HZHHq+mc2iyeHP7JaHJuxhNGB02N2w0UWj52z7rJ73Lm2
	h81j85J6jysnmlg9+rasYvT4vEkugD2KyyYlNSezLLVI3y6BK2PWWa2CrWwV68/0Mzcw9rF2
	MXJySAiYSFxYcQXKFpO4cG89WxcjF4eQwDJGic3LlzLCFL24+4YFIjGdUaL190Eo5y+jxKa1
	h9lBqtgENCQOv38GZosI+EusvzETbBSzQB+TRO/8VVBzGxglDkyZA1bFKRAs8WHleiYQW1gg
	VGLumh1g+1gEVCV+TpvCAmLzCthKfDq4jBHCFpT4MfkeWJxZQEdif+s0NghbW+LJuwtAT3AA
	3aou8eivLsQRRhInT7+AKheR2PfiHSPIDRICrRwSM/ses0HsEpD4NvkQC0SvrMSmA8wQL0tK
	HFxxg2UCo8QsJJtnIdk8C8nmWUhWLGBkWcUomlqQXFCclF5kolecmFtcmpeul5yfu4kREucT
	djDeO2B9iDEZaP1EZinR5HxgmsgriTc0NjOyMDUxNTYytzQjTVhJnFe9xTpQSCA9sSQ1OzW1
	ILUovqg0J7X4ECMTB6dUA6PRvo3fHJx55x3U+VvfVLjhUgJfTU9Jo4U7Z+okYylbDgMNn7Ba
	q8SPApnXOhc1h0iprrx42Lct2UzBoCGlJ97t/TJ2o69/OvOnvGZqn+3z/dXyGKM434qXJk77
	LSUYM47sfK6zurBVOvjWttd231iN6w6aG9qv3HjJTW3B1CwnKz6/Km5DJZbijERDLeai4kQA
	UVrjWwkDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrMKsWRmVeSWpSXmKPExsVy+t9jQV1VhfWBBuunGlmcXXaQzeLywkus
	Ft93fWG32PT4GqvF5V1z2CxmnN/HZHHq+mc2iyeHP7JaHJuxhNGB02N2w0UWj52z7rJ73Lm2
	h81j85J6jysnmlg9+rasYvT4vEkugD2qgdEmIzUxJbVIITUvOT8lMy/dVsk7ON453tTMwFDX
	0NLCXEkhLzE31VbJxSdA1y0zB+g0JYWyxJxSoFBAYnGxkr4dpgmhIW66FjCNEbq+IUFwPUYG
	aCBhHWPGrLNaBVvZKtaf6WduYOxj7WLk5JAQMJF4cfcNC4QtJnHh3nq2LkYuDiGB6YwSrb8P
	skA4fxklNq09zA5SxSagIXH4/TMwW0TAX2L9jZlgHcwCfUwSvfNXQbU3MEocmDIHrIpTIFji
	w8r1TCC2sECoxNw1OxhBbBYBVYmf06aA7eYVsJX4dHAZI4QtKPFj8j2wOLOAjsT+1mlsELa2
	xJN3F4Du5gC6VV3i0V9diCOMJE6efgFVLiKx78U7xgmMQrOQTJqFZNIsJJNmIWlZwMiyilE0
	tSC5oDgpPddQrzgxt7g0L10vOT93EyM4iTyT2sG4ssHiEKMAB6MSD+8HhnWBQqyJZcWVuYcY
	JTiYlUR4L/0GCvGmJFZWpRblxxeV5qQWH2JMBnp0IrOUaHI+MMHllcQbGpuYGVkamVkYmZib
	kyasJM57oNU6UEggPbEkNTs1tSC1CGYLEwenVANjqMDs2ND8pqbfmlNVL2ptbr8vn7vpza09
	EQ+lP6nsEFpm9KmZgcs8nnuBLc8O7gkbWvp33D/dfLmt7/JkN7F++1lzbncsqbk4OcBAoY5h
	/9rl+cXqS09FB8UYrkyfvW5bhH3GTel/hn8eRSpduepXJqYV6XVUoStAvuZQ8DwFX+aJ096t
	LQpUYinOSDTUYi4qTgQAmCnAAmYDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vikas Sajjan wrote:
> 
> Hi Mr. Jingoo Han,
> 
> On Sat, May 11, 2013 at 1:12 PM, Jingoo Han <jg1.han@samsung.com> wrote:
> The transition to common clock happened; however, DP (Display Port)
> clock node was not added. Thus, DP (Display Port) clock node should
> be added to the device tree.
> 
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> ---
> Tested on Exynos5250
> 
>  arch/arm/boot/dts/exynos5250.dtsi |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)

[...]

>  I have already sent similar patch on 8th May 2013.
> 
> http://www.spinics.net/lists/linux-samsung-soc/msg18136.html

Vikas, please don't use html typed e-mail :-(

OK, I found Jingoo's ack on that.

Let me take that with Jingoo's ack and Doug's review tag.

Thanks.

- Kukjin

