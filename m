Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757645Ab3LFKcg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 05:32:36 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:54383 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754481Ab3LFKcd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 05:32:33 -0500
X-AuditID: cbfee68d-b7f5c6d000004aff-14-52a1a7c0d2a6
Message-id: <52A1A7E2.2090304@samsung.com>
Date: Fri, 06 Dec 2013 19:33:06 +0900
From: Joonyoung Shim <jy0922.shim@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130803
 Thunderbird/17.0.8
MIME-version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input@vger.kernel.org, Sachin Kamat <sachin.kamat@linaro.org>,
        Jingoo Han <jg1.han@samsung.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Input: samsung-keypad - favor platform data if present
References: <20131206100215.GA27763@core.coreip.homeip.net>
In-reply-to: <20131206100215.GA27763@core.coreip.homeip.net>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrKIsWRmVeSWpSXmKPExsWyRsSkQPfA8oVBBtNXCFgcXvSC0eLywkus
	Fjc/fWO1uLxrDpvFyT+9jBbHZixhdGDz2DnrLrvHnWt72Dz6tqxi9Pi8SS6AJYrLJiU1J7Ms
	tUjfLoErY9nZ08wFL5grns/bw9bAOJW5i5GTQ0LAROLm4bNsELaYxIV764FsLg4hgaWMEq8a
	J7LDFP3buosZIrGIUWLOkkVMEM4rRomZ3ZtYQKp4BbQkHp08CDaKRUBV4smce2A2m4CexJ1t
	x5lAbFGBMIkXr3YxQ9QLSvyYfA+sV0RAX2L77F+MIDazwHZGiSevMkBsYQFvie07j4PFhQSs
	JT6fuAs2h1PARqKt/wobRL21xMpJ26B65SU2r3kLdqmEwCF2iabn05ggDhKQ+Db5ENAyDqCE
	rMSmA1DvS0ocXHGDZQKj2CwkJ81CMnYWkrELGJlXMYqmFiQXFCelFxnqFSfmFpfmpesl5+du
	YgRG2el/z3p3MN4+YH2IMRlo5URmKdHkfGCU5pXEGxqbGVmYmpgaG5lbmpEmrCTOm/QwKUhI
	ID2xJDU7NbUgtSi+qDQntfgQIxMHp1QDY9nil+UhRY+ZU3lvKiaHFM39PPOVr/q6iknmvDnH
	eL2WbtYLMLrpVLE6J8bpDOMCVjfTTD3ZTeYKcsEy+yW8eSsF5mZZ9c3/ohloHs7EHvWV5/0q
	DVPdkiPubl0nTFpE5ogciEo7P/+OgVv0/d+G3IWKSvy8WyKudqRIOi7t2fzqF7PQchklluKM
	REMt5qLiRADRrrrzyAIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprEKsWRmVeSWpSXmKPExsVy+t9jAd0DyxcGGWxayGlxeNELRovLCy+x
	Wtz89I3V4vKuOWwWJ//0Mlocm7GE0YHNY+esu+wed67tYfPo27KK0ePzJrkAlqgGRpuM1MSU
	1CKF1Lzk/JTMvHRbJe/geOd4UzMDQ11DSwtzJYW8xNxUWyUXnwBdt8wcoO1KCmWJOaVAoYDE
	4mIlfTtME0JD3HQtYBojdH1DguB6jAzQQMIaxoxlZ08zF7xgrng+bw9bA+NU5i5GTg4JAROJ
	f1t3QdliEhfurWfrYuTiEBJYxCgxZ8kiJgjnFaPEzO5NLCBVvAJaEo9OHmQDsVkEVCWezLkH
	ZrMJ6Enc2XacCcQWFQiTePEKYiqvgKDEj8n3wHpFBPQlts/+xQhiMwtsZ5R48ioDxBYW8JbY
	vvM4WFxIwFri84m7YHM4BWwk2vqvsEHUW0usnLQNqldeYvOat8wTGAVmIVkxC0nZLCRlCxiZ
	VzGKphYkFxQnpeca6RUn5haX5qXrJefnbmIEx/Az6R2MqxosDjEKcDAq8fByrFoQJMSaWFZc
	mXuIUYKDWUmEt2fewiAh3pTEyqrUovz4otKc1OJDjMnAEJjILCWanA9ML3kl8YbGJmZGlkbm
	hhZGxuakCSuJ8x5stQ4UEkhPLEnNTk0tSC2C2cLEwSnVwNhrfFHKyWS5zMaoN1PU5uRNO9l4
	7eVs7lfs+o+/KiT9c6oOWS26f/JV99Ld7gt5KxxYZlddUztuVmw4XdJcJtLlTd89gdciZ3ZL
	fvNYklc743Vs7pfwzpdMmzZcW2OQZpDHNe3Bn4yU2KkrOV5cVbu5Nmom3yL9BZW6blKz61MP
	XnjxMql3k6gSS3FGoqEWc1FxIgD1cuwGJQMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 12/06/2013 07:02 PM, Dmitry Torokhov wrote:
> We should be able to override firmware-provided parameters with in-kernel
> data, if needed. To that effect favor platform data, if present, over
> devicetree data.
>
> Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
> ---
>   drivers/input/keyboard/samsung-keypad.c | 36 +++++++++++++++++++--------------
>   1 file changed, 21 insertions(+), 15 deletions(-)

Acked-by: Joonyoung Shim <jy0922.shim@samsung.com>

Thanks.
