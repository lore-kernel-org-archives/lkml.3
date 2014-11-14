Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935245AbaKNN0A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 08:26:00 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:63549 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933794AbaKNNZ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 08:25:56 -0500
X-AuditID: cbfee68e-f79b46d000002b74-29-546602e1609e
Message-id: <546602E1.3080800@samsung.com>
Date: Fri, 14 Nov 2014 22:25:53 +0900
From: Jaehoon Chung <jh80.chung@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101
 Thunderbird/24.6.0
MIME-version: 1.0
To: Doug Anderson <dianders@chromium.org>, Addy Ke <addy.ke@rock-chips.com>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Seungwon Jeon <tgih.jun@samsung.com>, Chris Ball <chris@printf.net>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Dinh Nguyen <dinguyen@altera.com>,
        =?UTF-8?B?SGVpa28gU3TDvGJuZXI=?= <heiko@sntech.de>,
        Olof Johansson <olof@lixom.net>, Sonny Rao <sonnyrao@chromium.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        "zhenfu.fang" <zhenfu.fang@rock-chips.com>,
        Eddie Cai <cf@rock-chips.com>, lintao <lintao@rock-chips.com>,
        chenfen <chenfen@rock-chips.com>, zyf <zyf@rock-chips.com>,
        Jianqun Xu <xjq@rock-chips.com>, Tao Huang <huangtao@rock-chips.com>,
        Chris <zyw@rock-chips.com>,
        =?UTF-8?B?5aea5pm65oOF?= <yzq@rock-chips.com>,
        han jiang <hj@rock-chips.com>, Kever Yang <kever.yang@rock-chips.com>,
        zhangqing <zhangqing@rock-chips.com>, Lin Huang <hl@rock-chips.com>
Subject: Re: [PATCH v4] mmc: dw_mmc: add support for the other bit of sdio
 interrupt
References: <1414977633-3196-1-git-send-email-addy.ke@rock-chips.com>
 <1415109789-7046-1-git-send-email-addy.ke@rock-chips.com>
 <CAD=FV=XGjDZRBw7re8aRHdzNAq5cmtfpZ5RMdQ7o1CzbFMVXjw@mail.gmail.com>
In-reply-to: <CAD=FV=XGjDZRBw7re8aRHdzNAq5cmtfpZ5RMdQ7o1CzbFMVXjw@mail.gmail.com>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA02Sa0hTYRjHe897dpwj6bhcvQ26LSKQbt7qiaKi66E+FFgGBdnJTnbRtTaL
	Lh8akauU1jRq6HTOUlPRimlNKlPXQrPr1DSXmN3LC5VaWZHrbCvw2+99/s/zf/4vPFIsb5Mo
	pbvVKYJWzSepGBldFha9f9YraueGuf36CCjy/qAg9VQ3Ax+zGiRganYgyHM9lsCjojoG6psu
	YTjbmy8B7+seCdzreUbD0LVGDJW2Hxged5cguGH+yUDOl61gf9MqgXxDAQ3NN3MYcHnPIujv
	8mIobHNT0Ng2wIDJXE5DX4eZhtRqVxC8fZiF4MtLN4b68k2QaZND7pUCBjwZ7WJ/70cMJ36/
	oSCvqwovVXGp1SaGK7OWIc6id9Ncs/EMxZVcHmS4iuJwzl56muE6Wm+Lr4JjXEvDcQn3vDuf
	4v5k19CcsbIUcY5WK+YG7JPWj9ksW7RDSNp9UNDOWbxNtuttSyOj+So95MhU65EhKA0FSwkb
	TQxXKukAjyNPO68yPpazhYjUpK/539N26cm/uhmRd+6QNCQTuQeRX55eyieEsOHk5qDbzzQ7
	nViMRuRjhp1JHN/r/XUFG0ecBuu//lAydK7TvziMXUs85Z+RzxSzLTLyu8+DfcJYcaCjb5gK
	bGtA5EVuiX86mI0lnpN5fsbsDJJpvYgDPJlUlPVh3wBhm4KJyWOgA5FY8v2cU2SpKEwk9loc
	+NoEUlf8nDahcdkjQmWPsM0eYWtDuBQpBE2CRrc9URs5W8cn6w6oE2cn7Eu2I/HeHgy/N1ah
	9tqFTsRKkWp0yP5iYYNcwh/UHU52ohgxRQZWKhL2iSeqTomPiJoXCTHRMVGR8xfMU40P2ab8
	GStnE/kUYa8gaARtvPZAkqBzIkoarNQj67pcnL6n+DrftcUStbbiE50xgavdeNjxZFC48G1Z
	+HL3gNdgy+KnXNWs0lfFufZCunfqtJXK+1vX5LjW3U8z99fx1UM2d9X42qOKD0vSgmJDB1M6
	N7mXrD4f3/7rfcasI1F3h2+NmrjyxvLzcRtzLc+aEo6umHmnXVE0f8riEsvqHBWt28VHhGOt
	jv8Lfq7Mg2oDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrEJsWRmVeSWpSXmKPExsVy+t9jQd2HTGkhBveOq1os+/+dyaK14xWb
	xYuZJ1gtJlzezmgx/8g5Vouzyw6yWRy/tJjZov/NQlaL/49es1ocfX2VxeLHhlPMFlsWfGe2
	OPdqJaPFtuk/2SzmfIiz2PT4GqvFwrYlLBaXd81hszjyv5/R4tOD/8wWS69fZLI4df0zm8WE
	6WtZLN7emc5i0br3CLvFkzMzGS0+3L/IbHF8bbjFpAVCFnPXLWGzuDXxJlD9mxfMFi2/HzNZ
	zH+wg9lByaN17wQ2jzXz1jB6zG64yOJxua+XyWPl8i9sHptXaHlsWtXJ5nHn2h4gb0m9x5UT
	TaweN14tZPL4O2s/i0ffllWMHtuvzWP2+LxJLoA/qoHRJiM1MSW1SCE1Lzk/JTMv3VbJOzje
	Od7UzMBQ19DSwlxJIS8xN9VWycUnQNctMwcYdkoKZYk5pUChgMTiYiV9O0wTQkPcdC1gGiN0
	fUOC4HqMDNBAwhrGjCdXTrEVfOSo2D4pr4Gxjb2LkZNDQsBE4vri82wQtpjEhXvrwWwhgemM
	Ek8v8nYxcgHZrxklft16wwSS4BXQktj15SKYzSKgKjG7r48RxGYT0JHY/u04WFxUIEziUNs8
	qHpBiR+T77GA2CIC3hK31r5nBBnKLHCFS+L321vMIAlhoIY7b/8xQWw7wShxe+5KsG5OgWCJ
	W+3zwWxmAXWJSfMWMUPY8hKb17xlnsAoMAvJkllIymYhKVvAyLyKUTS1ILmgOCk910ivODG3
	uDQvXS85P3cTIzh9PpPewbiqweIQowAHoxIPL6NbaogQa2JZcWXuIUYJDmYlEd7vz4FCvCmJ
	lVWpRfnxRaU5qcWHGE2BYTCRWUo0OR+Y2vNK4g2NTcyMLI3MDS2MjM2VxHkPtloHCgmkJ5ak
	ZqemFqQWwfQxcXBKNTBapR3vWy0VujSqpvdyN1P1ZOaru92rW2ZeWnVw+b44le/7rtecbMoz
	2plmwBixgHPnqu+mOk+V5t/Yob83WMh3ugdjytR/X1k7m74H3WQpDLC0ZMn1Zl7LNuXmE770
	A4/FQ8vdMr/zTql8N+1zDI/QjsCYCDWneYzs8ncTu7tkDK+lTbWuEVBiKc5INNRiLipOBAC9
	JsBVtQMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/14/2014 03:58 AM, Doug Anderson wrote:
> Addy,
> 
> On Tue, Nov 4, 2014 at 6:03 AM, Addy Ke <addy.ke@rock-chips.com> wrote:
>> The bit of sdio interrupt is 16 in designware implementation,
>> but it is 24 on Rockchip SoCs.This patch add sdio_id0 for the
>> number of slot0 in the SDIO interrupt registers.
>>
>> Signed-off-by: Addy Ke <addy.ke@rock-chips.com>
>> ---
>> Changes in v2:
>> - rebase on http://git.linaro.org/git/people/ulf.hansson/mmc.git, next branch
>> Changes in v3:
>> - Remove dts for sdio_id0, just replace this with 8, suggested by Doug
>> - Change to support all Rockchip Socs, suggested by Heiko
>> Changes in v4:
>> - use init-hook to set sdio_id0, suggested by Jaehoon
>>
>>  drivers/mmc/host/dw_mmc-rockchip.c | 10 ++++++++++
>>  drivers/mmc/host/dw_mmc.c          | 12 +++++++-----
>>  drivers/mmc/host/dw_mmc.h          |  2 ++
>>  include/linux/mmc/dw_mmc.h         |  3 +++
>>  4 files changed, 22 insertions(+), 5 deletions(-)
> 
> Reviewed-by: Doug Anderson <dianders@chromium.org>
> 

Acked-by: Jaehoon Chung <jh80.chung@samsung.com>

Best Regards,
Jaehoon Chung


