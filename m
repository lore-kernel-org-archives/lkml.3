Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753615AbaFQAjz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 20:39:55 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:28567 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751668AbaFQAjx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 20:39:53 -0400
X-AuditID: cbfee691-b7f2f6d0000040c4-6f-539f8e57e2b9
Message-id: <539F8E57.4060502@samsung.com>
Date: Tue, 17 Jun 2014 09:39:51 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: broonie@kernel.org
Cc: Chanwoo Choi <cw00.choi@samsung.com>, lgirdwood@gmail.com,
        grant.likely@linaro.org, robh+dt@kernel.org, myungjoo.ham@samsung.com,
        kyungmin.park@samsung.com, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCHv2 0/2] regulator: of: Add support for pasing regulator
 suspend state
References: <1402447283-11356-1-git-send-email-cw00.choi@samsung.com>
In-reply-to: <1402447283-11356-1-git-send-email-cw00.choi@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrJIsWRmVeSWpSXmKPExsWyRsSkWDe8b36wweReSYupD5+wWVz/8pzV
	Yv6Rc6wWB/7sYLQ42/SG3eLblQ4mi8u75rBZ3G5cwWbRuvcIuwOnx85Zd9k9Nq3qZPO4c20P
	m0ffllWMHp83yQWwRnHZpKTmZJalFunbJXBlHPz6grGgm6/i6mbrBsZp3F2MnBwSAiYSUw51
	sELYYhIX7q1n62Lk4hASWMooMfPDL3aYookbbrJCJBYxStxtXg3lvGaUWHz+KTNIFa+AlsTM
	lg9gNouAqsTs9htgY9mA4vtf3GADsUUFwiRWTr/CAlEvKPFj8j0wWwRo9e05ncwgQ5kF7jNK
	/D08lxEkISwQJbHrzFkwW0jAVWLxpXawQZwCbhI3pm8Cs5kFdCT2t06DsuUlNq95CzZIQuAa
	u8SB/vWMEBcJSHybfAhoGwdQQlZi0wFmiNckJQ6uuMEygVFsFpKbZiEZOwvJ2AWMzKsYRVML
	kguKk9KLTPWKE3OLS/PS9ZLzczcxAqPx9L9nE3cw3j9gfYgxGWjlRGYp0eR8YDTnlcQbGpsZ
	WZiamBobmVuakSasJM6b/igpSEggPbEkNTs1tSC1KL6oNCe1+BAjEwenVANjR3Wg4UbetEVz
	Qn84JjFOtQzeYsP57Zfp9O+26l7/um+c761gKVE/u8sx63TClMMnFsz4kK/zIl5RsWTNwVmN
	q/iUglqs7Fzk7l0rLTzk9XMfT/a08zd2RRVsSuytffPYT/r4H2ML8+wnh9o/8qbpJvV8kJql
	/I+9WkOW82bUkXNnNrFxnD+sxFKckWioxVxUnAgA+TQFBtwCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrGKsWRmVeSWpSXmKPExsVy+t9jAd3wvvnBBgenCFpMffiEzeL6l+es
	FvOPnGO1OPBnB6PF2aY37BbfrnQwWVzeNYfN4nbjCjaL1r1H2B04PXbOusvusWlVJ5vHnWt7
	2Dz6tqxi9Pi8SS6ANaqB0SYjNTEltUghNS85PyUzL91WyTs43jne1MzAUNfQ0sJcSSEvMTfV
	VsnFJ0DXLTMH6CIlhbLEnFKgUEBicbGSvh2mCaEhbroWMI0Rur4hQXA9RgZoIGENY8bBry8Y
	C7r5Kq5utm5gnMbdxcjJISFgIjFxw01WCFtM4sK99WxdjFwcQgKLGCXuNq9mhXBeM0osPv+U
	GaSKV0BLYmbLBzCbRUBVYnb7DbBuNqD4/hc32EBsUYEwiZXTr7BA1AtK/Jh8D8wWAdpwe04n
	M8hQZoH7jBJ/D89lBEkIC0RJ7DpzFswWEnCVWHypHWwQp4CbxI3pm8BsZgEdif2t06BseYnN
	a94yT2AUmIVkxywkZbOQlC1gZF7FKJpakFxQnJSea6RXnJhbXJqXrpecn7uJERzrz6R3MK5q
	sDjEKMDBqMTD+0B2frAQa2JZcWXuIUYJDmYlEV4uc6AQb0piZVVqUX58UWlOavEhxmRgEExk
	lhJNzgemobySeENjEzMjSyNzQwsjY3PShJXEeQ+2WgcKCaQnlqRmp6YWpBbBbGHi4JRqYIxj
	vyQSuHGOZWqQ6+b61z+9msOM9fiVbX9xJbneP6/gIMOpZTJ9Zc7BhLlMtskbo1ckZS9P7Lct
	fKmwtFTaxivG0CT9Q6DAF9+LB/adDvE7Ln+FxVpFs/iLwbGl7Tn1Naa7azW6rh4M/un0Z6nP
	Lu61TtY1GbcUK1022ev5lhn+/fFF2GKhEktxRqKhFnNRcSIAwkLDJjkDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

Could you please review this patchset?

Best Regards,
Chanwoo Choi

On 06/11/2014 09:41 AM, Chanwoo Choi wrote:
> The regulators would set different state/mode according to the kind of suspend
> state. So regulation_constraints structure has already regulator suspend state filed.
> This patch parse regulator suspend state from devicetree file.
> 
> For example:
> 
> 	ldoX_reg: LDOx {
> 		regulator-name = "VAP_XXX_1.2V";
> 		regulator-min-microvolt = <1200000>;
> 		regulator-max-microvolt = <1200000>;
> 		regulator-always-on;
> 
> 		regulator-initial-state = <3>;	/* PM_SUSPEND_MEM */
> 		regulator-state-standby {
> 			regulator-volt = <1200000>;
> 			regulator-mode = <0x2>;	/* REGULATOR_MODE_NORMAL */
> 		};
> 
> 		regulator-state-mem {
> 			regulator-volt = <1200000>;
> 			regulator-mode = <0x8>;	/* REGULATOR_MODE_STANDBY */
> 			regulator-off-in-suspend;
> 		};
> 
> 		regulator-state-disk {
> 			regulator-volt = <1200000>;
> 			regulator-mode = <0x2>;	/* REGULATOR_MODE_NORMAL */
> 			regulator-on-in-suspend;
> 		};
> 	};
> 
> Changes from v1:
> - Check whether regulator-initial-state and regulator-mode is correct or not
> - Add more detailed description about regulator-initial-state, regulator-mode
>   and regulator-state-[standby/mem/disk] for devicetree bindings
> - Modify example of regulator suspend state in bindings documentation
> 
> Chanwoo Choi (2):
>   regulator: of: Add support for parsing regulator_state for suspend state
>   dt-bindings: regulator: Add regulator suspend state for PM state
> 
>  .../devicetree/bindings/regulator/regulator.txt    | 32 +++++++++
>  drivers/regulator/of_regulator.c                   | 76 +++++++++++++++++++++-
>  2 files changed, 106 insertions(+), 2 deletions(-)
> 

