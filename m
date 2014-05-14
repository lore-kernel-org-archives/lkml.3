Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755282AbaENLzj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 07:55:39 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:53221 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753467AbaENLzi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 07:55:38 -0400
X-AuditID: cbfec7f5-b7fae6d000004d6d-45-537359b2c9cd
Message-id: <537359B1.1060908@samsung.com>
Date: Wed, 14 May 2014 13:55:29 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.5.0
MIME-version: 1.0
To: Grant Likely <grant.likely@linaro.org>
Cc: robh+dt@kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] of: Add of_device_destroy_children() function
References: <1399567069-3174-1-git-send-email-s.nawrocki@samsung.com>
 <20140514102754.BC60BC4153D@trevor.secretlab.ca>
In-reply-to: <20140514102754.BC60BC4153D@trevor.secretlab.ca>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrNLMWRmVeSWpSXmKPExsVy+t/xK7qbIouDDXreyljMP3KO1eLAnx2M
	FpseX2O1uLxrDptF694j7A6sHptWdbJ53Lm2h81j85J6j8+b5AJYorhsUlJzMstSi/TtErgy
	ps91KljOVnHs12SWBsYe1i5GDg4JAROJvxu0uxg5gUwxiQv31rN1MXJxCAksZZR4tvUmO4Tz
	iVFi3c6JrCBVvAJaEq8fzWQBsVkEVCWmzPrFDmKzCRhK9B7tYwQZKioQIfH4ghBEuaDEj8n3
	wMpFgFqfzPnMBmIzC1RIrDk3B8wWFnCSmHNhEtgYIaD40p9TwGxOAVuJ103trBD1OhL7W6dB
	9cpLbF7zlnkCo8AsJCtmISmbhaRsASPzKkbR1NLkguKk9FwjveLE3OLSvHS95PzcTYyQAP66
	g3HpMatDjAIcjEo8vD9XFQULsSaWFVfmHmKU4GBWEuFltCgOFuJNSaysSi3Kjy8qzUktPsTI
	xMEp1cC4YfdfOW/ntWHJf/418O/Z+sBxNces+5IFK04w1wtrT7lk/+FS39JLBiUdOWH/J9YL
	FU35/0Y/7Kjx0VSbvc7zU6eXaNccljXYqv+Nkf+5zQbb/4c+TH3ouMhAZ8r3T7vt0+8nOKUd
	y2eQfHT1EEd++BHblIgZscnHpwY56U1rtD8j0J8stfC2EktxRqKhFnNRcSIAVgKapD4CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14/05/14 12:27, Grant Likely wrote:
> On Thu, 08 May 2014 18:37:49 +0200, Sylwester Nawrocki <s.nawrocki@samsung.com> wrote:
>> > This patch adds a helper function to unregister devices which
>> > were created by an of_platform_populate() call. The pattern
>> > used here can already be found in multiple drivers. This helper
>> > can now be used instead of repeating similar code in drivers.
>> > 
>> > Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
>> > Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
>> > ---
>
> Pawel has also submitted a patch for this. That patch is a little more
> careful about how it removes nodes, so I'll be going with that one.

OK, it's good to know we have already a good solution. I'll give a try
Pawel's patch then.

Thanks,
Sylwester
