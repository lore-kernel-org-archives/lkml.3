Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752607AbaFBINZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 04:13:25 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:8322 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751442AbaFBINX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 04:13:23 -0400
X-AuditID: cbfee691-b7f2f6d0000040c4-4f-538c321f7255
From: Jungseok Lee <jays.lee@samsung.com>
To: "'Christoffer Dall'" <christoffer.dall@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        "'Catalin Marinas'" <Catalin.Marinas@arm.com>,
        "'Marc Zyngier'" <Marc.Zyngier@arm.com>, linux-kernel@vger.kernel.org,
        "'linux-samsung-soc'" <linux-samsung-soc@vger.kernel.org>,
        "'Steve Capper'" <steve.capper@linaro.org>,
        =?UTF-8?B?J+ygleyEseynhCc=?= <sungjinn.chung@samsung.com>,
        "'Arnd Bergmann'" <arnd@arndb.de>,
        "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Ilho Lee'" <ilho215.lee@samsung.com>
References: <000201cf6dc6$3ed91500$bc8b3f00$@samsung.com>
 <CAMJs5B8MW_Abni2X=+bdywg9zz5JyaEcDmZ+0MLd79Pn1+ZYtg@mail.gmail.com>
In-reply-to: <CAMJs5B8MW_Abni2X=+bdywg9zz5JyaEcDmZ+0MLd79Pn1+ZYtg@mail.gmail.com>
Subject: Re: [PATCH v6 3/7] arm64: Add a description on 48-bit address space
 with 4KB pages
Date: Mon, 02 Jun 2014 17:13:19 +0900
Message-id: <07ff01cf7e3a$83442d40$89cc87c0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQIZ4dQCeF4L97XMXjWIgyzTt44hcAIK9AiMmrhZmBA=
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmphleLIzCtJLcpLzFFi42I5/e+Zsa68UU+wwYlNshZ/Jx1jt3i/rIfR
	4sXrf4wWR/8tZLToXXCVzeLjqePsFpseX2O1uLxrDpvFjPP7mCz+3vnHZrFi3jI2iw8zVjI6
	8HismbeG0eP3r0mMHneu7WHzOL9pDbPH5iX1Hn1bVjF6fN4kF8AexWWTkpqTWZZapG+XwJVx
	bsIJ5oILrBXXbmk2MJ5m6WLk5JAQMJG4e+cDO4QtJnHh3nq2LkYuDiGBZYwSD4+eZ4cpertu
	PitEYhGjxOd3vSwQzh9Gic03prGBVLEJaEo8utsD1iEC1PH53jywUcwCF5klfvSdZAZJCAk0
	MEocu8AEYnMKBEts2d8KFOfgEBaIldixpwQkzCKgKvFh2SJWEJtXwFLiy8ol7BC2oMSPyffA
	zmYWUJeYNG8RM4QtL7F5zVtmiEsVJHacfc0IcYOVxMoLZ1ghakQk9r14xwhyj4TAQg6JVRPu
	MUMsE5D4NvkQC8gNEgKyEpsOQM2RlDi44gbLBEaJWUhWz0KyehaS1bOQrFjAyLKKUTS1ILmg
	OCm9yFSvODG3uDQvXS85P3cTIyQFTNzBeP+A9SHGZKD1E5mlRJPzgSkkryTe0NjMyMLUxNTY
	yNzSjDRhJXHe9EdJQUIC6YklqdmpqQWpRfFFpTmpxYcYmTg4pRoY5zQw+cUrVbdcsKwyLbp3
	MHrHqp4Fr5amnJKrTmZnyV1a+vZbmoHw1o3BOWuCPeYc1O5c9MU5+nLr6SVrMrVE2JsEY/0E
	lxpndZVInQpav7sjINDYYN6U3d5bSu4XznKz3eQ1mcF39/1e/Q/dDtLvHN++YcjZsVjCZ9Un
	fd97Ystcb/JeXsWixFKckWioxVxUnAgA5kdi3xcDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrIKsWRmVeSWpSXmKPExsVy+t9jAV15o55ggx+XJSz+TjrGbvF+WQ+j
	xYvX/xgtjv5byGjRu+Aqm8XHU8fZLTY9vsZqcXnXHDaLGef3MVn8vfOPzWLFvGVsFh9mrGR0
	4PFYM28No8fvX5MYPe5c28PmcX7TGmaPzUvqPfq2rGL0+LxJLoA9qoHRJiM1MSW1SCE1Lzk/
	JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8xN9VWycUnQNctMwfoUiWFssScUqBQQGJxsZK+HaYJ
	oSFuuhYwjRG6viFBcD1GBmggYR1jxrkJJ5gLLrBWXLul2cB4mqWLkZNDQsBE4u26+awQtpjE
	hXvr2boYuTiEBBYxSnx+18sC4fxhlNh8YxobSBWbgKbEo7s97CC2CFD353vzwDqYBS4yS/zo
	O8kMkhASaGCUOHaBCcTmFAiW2LK/FSjOwSEsECuxY08JSJhFQFXiw7JFYJt5BSwlvqxcwg5h
	C0r8mHwP7DpmAXWJSfMWMUPY8hKb17xlhrhUQWLH2deMEDdYSay8cIYVokZEYt+Ld4wTGIVm
	IRk1C8moWUhGzULSsoCRZRWjaGpBckFxUnqukV5xYm5xaV66XnJ+7iZGcIJ5Jr2DcVWDxSFG
	AQ5GJR7eH+o9wUKsiWXFlbmHGCU4mJVEeI+e7Q4W4k1JrKxKLcqPLyrNSS0+xJgM9OlEZinR
	5Hxg8ssriTc0NjEzsjQyszAyMTcnTVhJnPdgq3WgkEB6YklqdmpqQWoRzBYmDk6pBka5iM8K
	p/8auMZl92yWXHzss8CCRqu0lRWu4lceTgqOPvhFiDNb7LHcruvGuuuM+POvqOx7nF3/q5Wj
	+0myw69ZL31rPdpWqkVPf/t175P/L5wtprm9fNtS+XrqhaOqGycZvk4x8LtwV/rHmhW3Hu0z
	Yf2f6NY1pY378vWt9z9N55K8btXtomSpxFKckWioxVxUnAgAXweVZHQDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, May 28, 2014 5:26 AM, Christoffer Dall wrote:
> On Mon, May 12, 2014 at 06:40:44PM +0900, Jungseok Lee wrote:
> > This patch adds memory layout and translation lookup information about
> > 48-bit address space with 4K pages. The description is based on 4
> > levels of translation tables.
> >
> > Cc: Catalin Marinas <catalin.marinas@arm.com>
> > Cc: Steve Capper <steve.capper@linaro.org>
> > Signed-off-by: Jungseok Lee <jays.lee@samsung.com>
> > Reviewed-by: Sungjinn Chung <sungjinn.chung@samsung.com>
> > Acked-by: Kukjin Kim <kgene.kim@samsung.com>
> > ---
> 
> Looks reasonable to me:
> 
> Acked-by: Christoffer Dall <christoffer.dall@linaro.org>

Thank a lot!

- Jungseok Lee

