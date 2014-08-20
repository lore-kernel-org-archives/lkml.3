Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752162AbaHTEw2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 00:52:28 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:8566 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750866AbaHTEwZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 00:52:25 -0400
X-AuditID: cbfee68d-b7f2f6d0000062f0-9a-53f429846add
Message-id: <53F42984.2070209@samsung.com>
Date: Wed, 20 Aug 2014 13:52:20 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: amit daniel kachhap <amit.daniel@samsung.com>
Cc: Zhang Rui <rui.zhang@intel.com>,
        "Valentin, Eduardo" <eduardo.valentin@ti.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Lukasz Majewski <l.majewski@samsung.com>,
        naveen krishna <ch.naveen@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        devicetree@vger.kernel.org, LAK <linux-arm-kernel@lists.infradead.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Eduardo Valentin <edubezval@gmail.com>
Subject: Re: [PATCHv3] thermal: exynos: Add support for TRIM_RELOAD feature at
 Exynos3250
References: <1408450078-6296-1-git-send-email-cw00.choi@samsung.com>
 <1408492364-8012-1-git-send-email-cw00.choi@samsung.com>
 <CADGdYn45A2aYY97rmC2WkxnWfFitvdNNrYK-2Nt=VDrY6HyH_w@mail.gmail.com>
In-reply-to: <CADGdYn45A2aYY97rmC2WkxnWfFitvdNNrYK-2Nt=VDrY6HyH_w@mail.gmail.com>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrNIsWRmVeSWpSXmKPExsWyRsSkWLdV80uwweEWNouGqyEWG2esZ7W4
	+/wwo8X8I+dYLdbs/8lkMf/KNVaL3gVX2SzONr1ht3jzcDOjxabHQLHLu+awWXzuPcJoMeP8
	PiaLJw/72CzWz3jN4sDvsXPWXXaPxXteMnlsXlLv0bdlFaPH8RvbmTw+b5ILYIvisklJzcks
	Sy3St0vgyli17RJjwXLWignXm9kaGLewdDFyckgImEic+HETyhaTuHBvPVsXIxeHkMBSRone
	2x/hin7u3gKVmM4o8aLnNjuE85pR4uWUBWwgVbwCWhJn1lwG62ARUJU48O0tE4jNBhTf/+IG
	WI2oQJjEyulXWCDqBSV+TL4HZHNwiAgYSsz6Lg4yk1lgAqvErO0bWUFqhAWiJZbfaIXafIxR
	4s7dE2CDOAWCJd79/8sMYjMLqEtMmrcIypaX2LzmLTNIg4RAL4fEo4bZ7BAXCUh8m3wIbJuE
	gKzEpgPMEK9JShxccYNlAqPYLCQ3zUIydhaSsQsYmVcxiqYWJBcUJ6UXGeoVJ+YWl+al6yXn
	525iBEb06X/Pencw3j5gfYgxGWjlRGYp0eR8YELIK4k3NDYzsjA1MTU2Mrc0I01YSZw36WFS
	kJBAemJJanZqakFqUXxRaU5q8SFGJg5OqQbGwsqJsyJFvnH7Xirwjt88+4btW60YTu4Je9Vf
	nVSVCNz3zDHFMUrr6j1dHW2BeU+M5/JonJCUXip86d3VLba2f6vs9gQE7zkXMOXfesvLyxuf
	yW2L2TBV/tkVic9T5ihwz5syserKG8df0gvjqxrmMd9fmlI5Y/XKtblL0yIWfviSuVnMo2t6
	lxJLcUaioRZzUXEiAM1LevX+AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprFKsWRmVeSWpSXmKPExsVy+t9jQd0WzS/BBq2PLC0aroZYbJyxntXi
	7vPDjBbzj5xjtViz/yeTxfwr11gtehdcZbM42/SG3eLNw82MFpseA8Uu75rDZvG59wijxYzz
	+5gsnjzsY7NYP+M1iwO/x85Zd9k9Fu95yeSxeUm9R9+WVYwex29sZ/L4vEkugC2qgdEmIzUx
	JbVIITUvOT8lMy/dVsk7ON453tTMwFDX0NLCXEkhLzE31VbJxSdA1y0zB+hkJYWyxJxSoFBA
	YnGxkr4dpgmhIW66FjCNEbq+IUFwPUYGaCBhDWPGqm2XGAuWs1ZMuN7M1sC4haWLkZNDQsBE
	4ufuLWwQtpjEhXvrgWwuDiGB6YwSL3pus0M4rxklXk5ZAFbFK6AlcWbNZbBuFgFViQPf3jKB
	2GxA8f0vboDViAqESaycfoUFol5Q4sfke0A2B4eIgKHErO/iIDOZBSawSszavpEVpEZYIFpi
	+Y1WqM3HGCXu3D0BNohTIFji3f+/zCA2s4C6xKR5i6BseYnNa94yT2AUmIVkxywkZbOQlC1g
	ZF7FKJpakFxQnJSea6RXnJhbXJqXrpecn7uJEZwunknvYFzVYHGIUYCDUYmH16H9c7AQa2JZ
	cWXuIUYJDmYlEV42jS/BQrwpiZVVqUX58UWlOanFhxhNgUEwkVlKNDkfmMrySuINjU3MjCyN
	zA0tjIzNlcR5D7ZaBwoJpCeWpGanphakFsH0MXFwSjUwKtxbKBPLzHxbl//j59vGp2tMPzJ8
	Lbc4eUzJSWbmc6Mj4vkpB89yTTnz4mqdwX9+5W873u+2qHmxPGy38sV+/VK285GOkhrPtY/d
	NlkV2btLffH3fs2licy/ds9PElwZsnDFlhUulnc9Vz27+Ov3jy/VCzfLOM675vjaao/0YoX+
	S5rBwrkX5imxFGckGmoxFxUnAgCeqDrOLQMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Amit,

On 08/20/2014 01:51 PM, amit daniel kachhap wrote:
> On Wed, Aug 20, 2014 at 5:22 AM, Chanwoo Choi <cw00.choi@samsung.com> wrote:
>> This patch add support for TRIM_RELOAD feature at Exynos3250. The TMU of
>> Exynos3250 has two TRIMINFO_CON register.
>>
>> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
>> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
>> Cc: Zhang Rui <rui.zhang@intel.com>
>> Cc: Eduardo Valentin <edubezval@gmail.com>
>> Cc: Amit Daniel Kachhap <amit.daniel@samsung.com>
> The changes looks fine,
> Reviewed-by: Amit Daniel Kachhap <amit.daniel@samsung.com>
> 

Thanks for your review.

Best Regards,
Chanwoo Choi

