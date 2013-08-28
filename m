Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753656Ab3H1NLO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 09:11:14 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:60348 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752419Ab3H1NLM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 09:11:12 -0400
X-AuditID: cbfec7f4-b7f0a6d000007b1b-45-521df6ee4d4b
Message-id: <521DF6EC.6030206@samsung.com>
Date: Wed, 28 Aug 2013 15:11:08 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Mateusz Krawczuk <m.krawczuk@partner.samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>, Rob Landley <rob@landley.net>,
        Tomasz Figa <t.figa@samsung.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Leelakrishna A <l.krishna@samsung.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>
Subject: Re: [Patch v2] pinctrl: Add s5pv210 support to pinctrl-exynos
References: <1377608890-8528-1-git-send-email-m.krawczuk@partner.samsung.com>
 <CACRpkdYiB5OG-YPRozwEurPHECDzZjQUs2s_E8gCdeqDPyr+WA@mail.gmail.com>
In-reply-to: <CACRpkdYiB5OG-YPRozwEurPHECDzZjQUs2s_E8gCdeqDPyr+WA@mail.gmail.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupgkeLIzCtJLcpLzFFi42I5/e/4Nd1332SDDPafFbOYf+Qcq8Wb3g4W
	i94FV9ksdm65wWYx5c9yJotNj6+xWlzeNYfNYsb5fUwWp9ecYrZYev0ik8WE6WtZLA6vOMBk
	se7ldCDrTTurxauDbSwW62e8ZrE4NmMJo4Ogx5p5axg9Fny+wu7xevIERo9Xq2eyety5tofN
	Y/OSeo+D7/YwefRtWcXo8XmTnMfGuaEBXFFcNimpOZllqUX6dglcGa96t7IVbGOt6J37lqWB
	cTVLFyMHh4SAicS5k45djJxAppjEhXvr2boYuTiEBJYySlxdc5wZwvnEKNH6oIkFpIpXQEti
	3+o7jCA2i4CqxOf9s1hBbDYBQ4neo31gcVGBAInFS86xQ9QLSvyYfA+sV0RAR6J7209WkKHM
	Au9YJeYu7wUrEhZwk1jZ+Atq2xRGibcr+sGmcgoES/xc+pQNxGYG6t7fOg3KlpfYvOYt8wRG
	gVlIlsxCUjYLSdkCRuZVjKKppckFxUnpuYZ6xYm5xaV56XrJ+bmbGCGx92UH4+JjVocYBTgY
	lXh4LTbLBAmxJpYVV+YeYpTgYFYS4eXfLhskxJuSWFmVWpQfX1Sak1p8iJGJg1OqgdGE6fDG
	5a/Oamfu3rPe+rn4YYZJD4PuHb5hpFVo+nyhuImJSfJEIT/r80f3NSRKCLC1KC/yCn1lINEg
	FlLhs8TOujK4oVRA9vrVAo7pylVWP+Qco9fcyt7+vzyhxXiVfkbY/aKyKw8Ktq4q+Js2+2jI
	/MXnM6wFkk9PZpDqUrNa/DQ/wO7SDyWW4oxEQy3mouJEAFMtGEibAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/28/2013 02:51 PM, Linus Walleij wrote:
> On Tue, Aug 27, 2013 at 3:08 PM, Mateusz Krawczuk
> <m.krawczuk@partner.samsung.com> wrote:
> 
>> This patch implements pinctrl support and adds device tree bindings
>> for s5pv210.
>>
>> Signed-off-by: Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
> 
> Oh this one does add bindings, sorry for previous comment.
> 
> I want an ACK from Kukjin or Sylwester for this since it's
> something new for S5P.

I'm happy to see this, it will allow us to clean up some common
S5P/Exynos drivers by removing non-dt support from them, once
S5PV210 is converted to DT.


Regards,
-- 
Sylwester Nawrocki
Samsung R&D Institute Poland
