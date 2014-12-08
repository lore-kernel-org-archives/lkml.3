Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755292AbaLHLbA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 06:31:00 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:40147 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754646AbaLHLa6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 06:30:58 -0500
X-AuditID: cbfee690-f79ab6d0000046f7-0c-54858bf0edaf
Message-id: <54858BF6.4040407@samsung.com>
Date: Mon, 08 Dec 2014 17:01:02 +0530
From: Pankaj Dubey <pankaj.dubey@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.2.0
MIME-version: 1.0
To: Chanwoo Choi <cw00.choi@samsung.com>, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: kgene.kim@samsung.com, mark.rutland@arm.com, marc.zyngier@arm.com,
        arnd@arndb.de, olof@lixom.net, catalin.marinas@arm.com,
        will.deacon@arm.com, s.nawrocki@samsung.com, tomasz.figa@gmail.com,
        kyungmin.park@samsung.com, inki.dae@samsung.com,
        chanho61.park@samsung.com, geunsik.lim@samsung.com,
        sw0312.kim@samsung.com, jh80.chung@samsung.com, a.kesavan@samsung.com,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 02/19] clk: samsung: exynos5433: Add MUX clocks of CMU_TOP
 domain
References: <1417510196-6714-1-git-send-email-cw00.choi@samsung.com>
 <1417510196-6714-3-git-send-email-cw00.choi@samsung.com>
In-reply-to: <1417510196-6714-3-git-send-email-cw00.choi@samsung.com>
Content-type: text/plain; charset=windows-1252; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrEIsWRmVeSWpSXmKPExsWyRsSkSvdDd2uIQec1AYvHaxYzWfyddIzd
	4v2yHkaLy/u1La5/ec5qMf/IOVaLPxNa2Swm3Z/AYnHjVxurRe+Cq2wWZ5vesFtsenyN1eLy
	rjlsFjPO7wPqv/OPzWLp9YtMFqeuf2azOPymndVixuSXbBardv1htHj58QSLg6jHmnlrGD1+
	/5rE6LFz1l12j81L6j2unGhi9ejbsorR4/MmuQD2KC6blNSczLLUIn27BK6Mw3+msxZ0sVa0
	t0xja2CczdLFyMkhIWAisXHBU0YIW0ziwr31bF2MXBxCAksZJY48mskEU/Tn6CFmiMQiRonu
	Wb2MEE4rk8SHU32sIFW8AloSH0+cAhvLIqAq8WzKF7CxbAK6Ek/ez2UGsUUFIiSurJnDCFEv
	KPFj8j2wehGBbImnbw6DrWYW2Mkscb57ClhCWCBc4tLpf2BnCAnUS5y7/IQNxOYUcJX4f34e
	WA2zgK3EgvfroGx5ic1r3jJDnH2AQ+LoPj+IgwQkvk0+BFTDARSXldh0AKpEUuLgihssExjF
	ZiE5aRaSqbOQTF3AyLyKUTS1ILmgOCm9yESvODG3uDQvXS85P3cTIzApnP73bMIOxnsHrA8x
	CnAwKvHwLnjQEiLEmlhWXJl7iNEU6IqJzFKiyfnA1JNXEm9obGZkYWpiamxkbmmmJM77Wupn
	sJBAemJJanZqakFqUXxRaU5q8SFGJg5OqQbGluqfJofeSbZtCpjek/bnc5axDlvOwWl/ru6x
	+XTnfkSaFsta7oDT9ztDb3aUqDzfxJjLLayxuW1xJsOe1h/rkqZ/92L4J7jg523xcJE/AZpG
	fzS7M3SW/jU5v/hU/m9P/hMJbgHqrX7a7IoGs5Y94V2iJV0frXx8VmuSx8q29QYLy45LPHij
	xFKckWioxVxUnAgAGfPTBgUDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrLKsWRmVeSWpSXmKPExsVy+t9jAd0P3a0hBnufslk8XrOYyeLvpGPs
	Fu+X9TBaXN6vbXH9y3NWi/lHzrFa/JnQymYx6f4EFosbv9pYLXoXXGWzONv0ht1i0+NrrBaX
	d81hs5hxfh9Q/51/bBZLr19ksjh1/TObxeE37awWMya/ZLNYtesPo8XLjydYHEQ91sxbw+jx
	+9ckRo+ds+6ye2xeUu9x5UQTq0ffllWMHp83yQWwRzUw2mSkJqakFimk5iXnp2TmpdsqeQfH
	O8ebmhkY6hpaWpgrKeQl5qbaKrn4BOi6ZeYAfaWkUJaYUwoUCkgsLlbSt8M0ITTETdcCpjFC
	1zckCK7HyAANJKxhzDj8ZzprQRdrRXvLNLYGxtksXYycHBICJhJ/jh5ihrDFJC7cW8/WxcjF
	ISSwiFGie1YvI4TTyiTx4VQfK0gVr4CWxMcTp8C6WQRUJZ5N+cIIYrMJ6Eo8eT8XbJKoQITE
	lTVzGCHqBSV+TL4HVi8ikC3x9M1hsA3MAjuZJc53TwFLCAuES1w6/Y8JxBYSqJc4d/kJG4jN
	KeAq8f/8PLAaZgFbiQXv10HZ8hKb17xlnsAoMAvJjllIymYhKVvAyLyKUTS1ILmgOCk911Cv
	ODG3uDQvXS85P3cTIzjpPJPawbiyweIQowAHoxIP74IHLSFCrIllxZW5hxglOJiVRHgT41pD
	hHhTEiurUovy44tKc1KLDzGaAoNgIrOUaHI+MCHmlcQbGpuYmxqbWppYmJhZKonz3riZGyIk
	kJ5YkpqdmlqQWgTTx8TBKdXAyHrNborw2UOxdt7rfpq7XriQbHuEPaeqPaVE0WHhPTZOi+0V
	wW8VFJjjGr5d3KPdZ7FM9fxBbQEF6/OPbTumm+2bOXP+07+6WusWBcZ5a5wVKORqEd/pxbb3
	I1/l6sD/bIx7RZJn209PWR1gfb7s2os7yWd2qE2zf6vbc0p2oltVk93XnJWflFiKMxINtZiL
	ihMBzH9+o1ADAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chanwoo,

On Tuesday 02 December 2014 02:19 PM, Chanwoo Choi wrote:
> This patch adds the MUX (multiplexer) clocks for CMU_TOP domain of Exynos5433.
> CMU_TOP domain provides source clocks to other CMU domains.
>
> Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
> Cc: Tomasz Figa <tomasz.figa@gmail.com>
> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
> Acked-by: Inki Dae <inki.dae@samsung.com>
> Acked-by: Geunsik Lim <geunsik.lim@samsung.com>
> ---

Reviewed all registers and clock relationships w.r.t UM I have and all 
changes are OK. So

Reviewed-by: Pankaj Dubey <pankaj.dubey@samsung.com>

Thanks,
Pankaj Dubey
