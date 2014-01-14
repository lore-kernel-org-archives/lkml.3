Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751959AbaANQ3R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 11:29:17 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:44198 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751588AbaANQ3N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 11:29:13 -0500
X-AuditID: cbfec7f4-b7f796d000005a13-be-52d565d6006c
Message-id: <52D565D5.4050704@samsung.com>
Date: Tue, 14 Jan 2014 17:29:09 +0100
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.2.0
MIME-version: 1.0
To: Vladimir Barinov <vladimir.barinov@cogentembedded.com>,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Cc: anton@enomsg.org, dwmw2@infradead.org, mk7.kang@samsung.com,
        Kyungmin Park <kmpark@infradead.org>
Subject: Re: [PATCH 0/3] power_supply: modelgauge_battery: Add Maxim ModelGauge
 ICs gauge
References: <1389286145-15375-1-git-send-email-vladimir.barinov@cogentembedded.com>
In-reply-to: <1389286145-15375-1-git-send-email-vladimir.barinov@cogentembedded.com>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrLLMWRmVeSWpSXmKPExsVy+t/xy7rXUq8GGRz4bGhxcKumxfwj51gt
	Jq6czGzx+oWhxa3Lq1gsLu+aw2bRcaSF0aKv6yK7A4fHg6n/mTwm9H9i9Ni8Qsujb8sqRo/P
	m+QCWKO4bFJSczLLUov07RK4Mr4dbWUtuM1ScewifwPjM+YuRk4OCQETidmb77JD2GISF+6t
	Z+ti5OIQEljKKHFy+3p2COczo8SuB+dZQKp4BbQkJvQ0gXWzCKhKNF55zQZiswkYS2xevgTM
	FhWIkHh1diJUvaDEj8n3wGwRgTKJZTvPMHUxcnAwC6RLbLjvDhIWFoiW6JsM0soBtCtUYuNB
	RZAwp0CYxJwL85lAbGYBM4lHLeuYIWx5ic1r3jJPYBSYhWTBLCRls5CULWBkXsUomlqaXFCc
	lJ5rqFecmFtcmpeul5yfu4kREuRfdjAuPmZ1iFGAg1GJh/dn+NUgIdbEsuLK3EOMEhzMSiK8
	M6OBQrwpiZVVqUX58UWlOanFhxiZODilGhhZCi7ZMMbeeFH0SOxw/8aojBvPkn+1qHt+1XTf
	J7zDTig6T8u3/ALTljqhIwtsnFPPpN7anqAV7XdKQNghP56zrWTGx1MRSmxNB6oevV972qnq
	y6d0j9Nykno+S1f/TpBWsjx4Sm5XxL/eK7OulKnfvLKlIysn6bBjVMlNh+JP/8sj1r9aG6PE
	UpyRaKjFXFScCADhmWVLUAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/09/2014 05:49 PM, Vladimir Barinov wrote:
> Hello.
>
> This adds the folowing:
> - Maxim ModelGauge ICs gauge driver for MAX17040/41/43/44/48/49/58/59 chips
> - Document DT bindings
> - Remove superseded Maxim MAX17040 gauge driver
>
> Vladimir Barinov (3):
>   [1/3] power_supply: modelgauge_battery: Maxim ModelGauge ICs gauge
>   [2/3] dt: Document ModelGauge gauge bindings
>   [3/3] power_supply: modelgauge_battery: Remove Maxim MAX17040 gauge

On which tree your patchset is based on? I had conflicts when trying to
apply this on 3.12 and 3.13.

Best regards,
Krzysztof

