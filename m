Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751915Ab3FZBTQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 21:19:16 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:63361 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751314Ab3FZBTO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 21:19:14 -0400
X-AuditID: cbfee68e-b7f276d000002279-6f-51ca418f28c1
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
Message-id: <51CA418E.9000607@samsung.com>
Date: Wed, 26 Jun 2013 10:19:10 +0900
From: jonghwa3.lee@samsung.com
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:11.0) Gecko/20120411
 Thunderbird/11.0.1
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: Anton Vorontsov <anton.vorontsov@linaro.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Myungjoo Ham <myungjoo.ham@samsung.com>
Subject: Re: [PATCH 2/2] power: charger-manager: Fix a bug when it unregisters
 notifier block of extcon.
References: <1372136569-551-1-git-send-email-jonghwa3.lee@samsung.com>
 <1372136569-551-2-git-send-email-jonghwa3.lee@samsung.com>
 <CAGTfZH1q8b0VyDsSsFa7DooHbLN46PTYofCRXCYRThnuNRjCwg@mail.gmail.com>
In-reply-to: <CAGTfZH1q8b0VyDsSsFa7DooHbLN46PTYofCRXCYRThnuNRjCwg@mail.gmail.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrHIsWRmVeSWpSXmKPExsWyRsSkQLff8VSgwYRp6hYXW2+zWFz/8pzV
	4vKuOWwWtxtXsDmweNy5tofNo2/LKkaPz5vkApijuGxSUnMyy1KL9O0SuDLunV/LUvBUpOLc
	F54GxtX8XYycHBICJhKbz55jg7DFJC7cWw9kc3EICSxllLh3/BsTTNGuy4uYIBLTGSWO/NjI
	DpLgFRCU+DH5HguIzSygLjFp3iJmCFtE4t2Pn0wQtrbEsoWvmSGaXzJKrP/wng2iWUti3eN2
	RhCbRUBV4siLJWCD2ATkJN42fQOLiwqESVydcBwsLiKgITHz7xVGkEHMAl2MEl9engMrEhbI
	kjg15THUeacYJeaeWQW2gVMgWOLjzwdQP2xil7i0VBdim4DEt8mHgKZyAMVlJTYdYIYokZQ4
	uOIGywRG8VlInpuF5LlZSJ6bheS5BYwsqxhFUwuSC4qT0ouM9IoTc4tL89L1kvNzNzEC4+70
	v2d9OxhvHrA+xJgMtH4is5Rocj4wbvNK4g2NzYwsTE1MjY3MLc1IE1YS51VrsQ4UEkhPLEnN
	Tk0tSC2KLyrNSS0+xMjEwSnVwMh2u7yudBMrC/OJT4UPFtXPy63auYF3nressHx7xoZJ3D5b
	f0yO1S09/CN1Xjz7+u559Rq1TDFTj4XrzpNw3n7CseRE/Kn5xq4ffij753z6f0BjCYffGvZN
	RiofWc/6qhxZpmDpptnkXLD8r2zf1ZgLbSHnPjg4pofI7HlRan961Z6muu0qQkosxRmJhlrM
	RcWJAETLm37RAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpmleLIzCtJLcpLzFFi42I5/e+xoG6/46lAg0W35C0utt5msbj+5Tmr
	xeVdc9gsbjeuYHNg8bhzbQ+bR9+WVYwenzfJBTBHNTDaZKQmpqQWKaTmJeenZOal2yp5B8c7
	x5uaGRjqGlpamCsp5CXmptoqufgE6Lpl5gCtU1IoS8wpBQoFJBYXK+nbYZoQGuKmawHTGKHr
	GxIE12NkgAYS1jBmzL74hLngrEjF3KMH2RsYJ/N3MXJySAiYSOy6vIgJwhaTuHBvPVsXIxeH
	kMB0RokjPzaygyR4BQQlfky+x9LFyMHBLCAvceRSNkiYWUBdYtK8RcwQ9S8ZJdZ/eM8GUa8l
	se5xOyOIzSKgKnHkxRIWEJtNQE7ibdM3sLioQJjE1QnHweIiAhoSM/9eYQQZxCzQxSjx5eU5
	sCJhgSyJU1MeM0FsOMUoMffMKrANnALBEh9/PmCawCgwC8mBsxAOnIXkwAWMzKsYRVMLkguK
	k9JzjfSKE3OLS/PS9ZLzczcxgqP0mfQOxlUNFocYBTgYlXh4FbaeDBRiTSwrrsw9xCjBwawk
	wpt/AyjEm5JYWZValB9fVJqTWnyIMRnovYnMUqLJ+cAEklcSb2hsYmZkaWRuaGFkbE6asJI4
	78FW60AhgfTEktTs1NSC1CKYLUwcnFINjFk/DZVXrL7N8JNz5yPrTb+z/b82xv24z1f1w7Xq
	SPpH40ZWZf+TNzJvs55pyHg26X7Kr4ifedU8zQ6vr7Ey/Mzb3/Rxv+7FjDNzlxQk8z1UZnFZ
	pyC6vKs2uFptWtZ5U5aGIxHTxHcm/A6Q3fPxVWTE/Avi/t2WSvenCWQmPpy31vN7yNGwc0os
	xRmJhlrMRcWJANj8lS0WAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
On 2013년 06월 25일 22:34, Chanwoo Choi wrote:

> On Tue, Jun 25, 2013 at 2:02 PM, Jonghwa Lee <jonghwa3.lee@samsung.com
> <mailto:jonghwa3.lee@samsung.com>> wrote:
> 
>     This patch prevents NULL pointer error cauesed by unregistering unregistered
>     exton notifier block. At the probing time of charger manager, it tries to
>     remove extcon notifier block when it fails to initialize them. It has to be
>     applied for only registered one. Otherwise, it'd make kernel panic. To make it
>     work right, it checks extcon_specific_cable_nb's extcon_dev node. If extcon
>     cable notifier block was registered successfully, it has proper extcon_dev
>     pointer if not so it has NULL pointer.
> 
>     Signed-off-by: Jonghwa Lee <jonghwa3.lee@samsung.com
>     <mailto:jonghwa3.lee@samsung.com>>
>     Signed-off-by: Myungjoo Ham <myungjoo.ham@samsung.com
>     <mailto:myungjoo.ham@samsung.com>>
>     ---
>      drivers/power/charger-manager.c |    4 +++-
>      1 file changed, 3 insertions(+), 1 deletion(-)
> 
>     diff --git a/drivers/power/charger-manager.c b/drivers/power/charger-manager.c
>     index 7d1bcde..c55a7dc 100644
>     --- a/drivers/power/charger-manager.c
>     +++ b/drivers/power/charger-manager.c
>     @@ -1666,7 +1666,9 @@ err_reg_extcon:
>                     charger = &desc->charger_regulators[i];
>                     for (j = 0; j < charger->num_cables; j++) {
>                             struct charger_cable *cable = &charger->cables[j];
>     -                       extcon_unregister_interest(&cable->extcon_dev);
>     +                       /* Remove notifier block if only edev exists */
>     +                       if (cable->extcon_dev.edev)
>     +                               extcon_unregister_interest(&cable->extcon_dev);
>                     }
> 
>                     regulator_put(desc->charger_regulators[i].consumer);
>     --
>     1.7.9.5
> 
> 
> The charger-manager.c call extcon_unregister_interest() in
> charger_manager_remove() function.
> So, you should to fix it on charger_manager_remove() to remove NULL pointer error.
> 


When .remove() callback function is called, there is no unregistered cable
notifier block. Because all extcon notifier block would be registered at probing
time, and if it is failed the probing can't be achieved. So I think it doesn't
need to fix .remove() callback function as like above.

Thank you for reviewing.

Best regards,
Jonghwa.


> Acked-by: Chanwoo Choi <cw00.choi@samsung.com <mailto:cw00.choi@samsung.com>>
> 
> Thanks,
> Chanwoo Choi
>  


