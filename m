Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752060Ab3FZBWb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 21:22:31 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:34316 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751314Ab3FZBW3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 21:22:29 -0400
MIME-version: 1.0
Content-type: text/plain; charset=EUC-KR
X-AuditID: cbfee68f-b7f436d000000f81-e5-51ca4253270f
Content-transfer-encoding: 8BIT
Message-id: <51CA4254.3040200@samsung.com>
Date: Wed, 26 Jun 2013 10:22:28 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
To: jonghwa3.lee@samsung.com
Cc: Anton Vorontsov <anton.vorontsov@linaro.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Myungjoo Ham <myungjoo.ham@samsung.com>
Subject: Re: [PATCH 2/2] power: charger-manager: Fix a bug when it unregisters
 notifier block of extcon.
References: <1372136569-551-1-git-send-email-jonghwa3.lee@samsung.com>
 <1372136569-551-2-git-send-email-jonghwa3.lee@samsung.com>
 <CAGTfZH1q8b0VyDsSsFa7DooHbLN46PTYofCRXCYRThnuNRjCwg@mail.gmail.com>
 <51CA418E.9000607@samsung.com>
In-reply-to: <51CA418E.9000607@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrKIsWRmVeSWpSXmKPExsWyRsSkWDfY6VSgQfcNS4uLrbdZLDrPPmG2
	uLxrDpvF7cYVbA4sHneu7WHz6NuyitHj8ya5AOYoLpuU1JzMstQifbsErow9ixsYC7aIVXzo
	b2VvYLwi0MXIySEhYCLx++RMVghbTOLCvfVsXYxcHEICSxklpty/xQpTdLPpHSNEYhGjxM7/
	LxlBErwCghI/Jt9j6WLk4GAWkJc4cikbJMwsoCEx9fVpqPoXjBKPj89kBqnhFdCS2DVDFaSG
	RUBVYuHxbcwgNhtQeP+LG2wgtqhAmMTK6VdYQGwRARmJlVd/MoHMYQY6V+LLy3Nge4UFsiRO
	TXnMBLHgNaPEu54JYN2cAtoSB7vWs4IkJAQ2sUt83wxSBbJOQOLb5ENgl0oIyEpsOsAM8Zmk
	xMEVN1gmMIrNQvLPLIR/ZiH5ZwEj8ypG0dSC5ILipPQiY73ixNzi0rx0veT83E2MwCg6/e9Z
	/w7GuwesDzEmA22cyCwlmpwPjMK8knhDYzMjC1MTU2Mjc0sz0oSVxHnVWqwDhQTSE0tSs1NT
	C1KL4otKc1KLDzEycXBKNTB6hJgxtH1yNdhs7diw8piq4i/xX9ucghYuO8dxq/JLlFnrvJty
	a7vXOznwxEyMtFlYesh6Z4N1ZP4lISvW/V61Wj9slKSe+GR2H7dqNujcs9RCmDfpeX3ZvqRL
	+ls/lu7lesEj/ix98l+71N8XLswwyF6p/+qT7qHL7zI3pHDZNoRJJt8XKFViKc5INNRiLipO
	BADx4fJsuAIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpileLIzCtJLcpLzFFi42I5/e+xgG6w06lAg7NPjSwutt5mseg8+4TZ
	4vKuOWwWtxtXsDmweNy5tofNo2/LKkaPz5vkApijGhhtMlITU1KLFFLzkvNTMvPSbZW8g+Od
	403NDAx1DS0tzJUU8hJzU22VXHwCdN0yc4DWKSmUJeaUAoUCEouLlfTtME0IDXHTtYBpjND1
	DQmC6zEyQAMJaxgz9ixuYCzYIlbxob+VvYHxikAXIyeHhICJxM2md4wQtpjEhXvr2boYuTiE
	BBYxSuz8/xIswSsgKPFj8j2WLkYODmYBeYkjl7JBwswCGhJTX59mhKh/wSjx+PhMZpAaXgEt
	iV0zVEFqWARUJRYe38YMYrMBhfe/uMEGYosKhEmsnH6FBcQWEZCRWHn1JxPIHGagqyS+vDwH
	tldYIEvi1JTHTBALXjNKvOuZANbNKaAtcbBrPesERoFZSO6bhXDfLCT3LWBkXsUomlqQXFCc
	lJ5rqFecmFtcmpeul5yfu4kRHKPPpHYwrmywOMQowMGoxMOrsPVkoBBrYllxZe4hRgkOZiUR
	3vwbQCHelMTKqtSi/Pii0pzU4kOMyUDvTWSWEk3OB6aPvJJ4Q2MTMyNLI3NDCyNjc9KElcR5
	D7RaBwoJpCeWpGanphakFsFsYeLglGpgZLUxDl1eeSw+5yfXv7UhNZYPbjZO3cWdJLD36VyW
	XWLLtWWD1GNWTX+ue67GTlfMOqHt6kSVRYXhySv2ZGytyl36mZVlJfvHzLSW2265zJuWMps7
	7labM2Eqb5Pvnb+8LgEP1c5Mf+fBfSbLjdU7RfWi6FX+HVdnFbncz7Td9Fs7ULlvwhoRJZbi
	jERDLeai4kQACdqV2xUDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/26/2013 10:19 AM, jonghwa3.lee@samsung.com wrote:
> Hi,
> On 2013³â 06¿ù 25ÀÏ 22:34, Chanwoo Choi wrote:
> 
>> On Tue, Jun 25, 2013 at 2:02 PM, Jonghwa Lee <jonghwa3.lee@samsung.com
>> <mailto:jonghwa3.lee@samsung.com>> wrote:
>>
>>     This patch prevents NULL pointer error cauesed by unregistering unregistered
>>     exton notifier block. At the probing time of charger manager, it tries to
>>     remove extcon notifier block when it fails to initialize them. It has to be
>>     applied for only registered one. Otherwise, it'd make kernel panic. To make it
>>     work right, it checks extcon_specific_cable_nb's extcon_dev node. If extcon
>>     cable notifier block was registered successfully, it has proper extcon_dev
>>     pointer if not so it has NULL pointer.
>>
>>     Signed-off-by: Jonghwa Lee <jonghwa3.lee@samsung.com
>>     <mailto:jonghwa3.lee@samsung.com>>
>>     Signed-off-by: Myungjoo Ham <myungjoo.ham@samsung.com
>>     <mailto:myungjoo.ham@samsung.com>>
>>     ---
>>      drivers/power/charger-manager.c |    4 +++-
>>      1 file changed, 3 insertions(+), 1 deletion(-)
>>
>>     diff --git a/drivers/power/charger-manager.c b/drivers/power/charger-manager.c
>>     index 7d1bcde..c55a7dc 100644
>>     --- a/drivers/power/charger-manager.c
>>     +++ b/drivers/power/charger-manager.c
>>     @@ -1666,7 +1666,9 @@ err_reg_extcon:
>>                     charger = &desc->charger_regulators[i];
>>                     for (j = 0; j < charger->num_cables; j++) {
>>                             struct charger_cable *cable = &charger->cables[j];
>>     -                       extcon_unregister_interest(&cable->extcon_dev);
>>     +                       /* Remove notifier block if only edev exists */
>>     +                       if (cable->extcon_dev.edev)
>>     +                               extcon_unregister_interest(&cable->extcon_dev);
>>                     }
>>
>>                     regulator_put(desc->charger_regulators[i].consumer);
>>     --
>>     1.7.9.5
>>
>>
>> The charger-manager.c call extcon_unregister_interest() in
>> charger_manager_remove() function.
>> So, you should to fix it on charger_manager_remove() to remove NULL pointer error.
>>
> 
> 
> When .remove() callback function is called, there is no unregistered cable
> notifier block. Because all extcon notifier block would be registered at probing
> time, and if it is failed the probing can't be achieved. So I think it doesn't
> need to fix .remove() callback function as like above.
> 
> Thank you for reviewing.
> 
> Best regards,
> Jonghwa.
> 
> 
>> Acked-by: Chanwoo Choi <cw00.choi@samsung.com <mailto:cw00.choi@samsung.com>>
>>
>> Thanks,
>> Chanwoo Choi
>>  
> 

OK, I agree your opinion.

Acked-by: Chanwoo Choi <cw00.choi@samsung.com>

Thanks,
Chanwoo Choi

