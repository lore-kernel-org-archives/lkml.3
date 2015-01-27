Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758091AbbA0KJ6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 05:09:58 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:12272 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753338AbbA0KJz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 05:09:55 -0500
X-AuditID: cbfee61b-f79d76d0000024d6-6d-54c763f1be2a
Date: Tue, 27 Jan 2015 11:09:48 +0100
From: Lukasz Majewski <l.majewski@samsung.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Valentin Rothberg <valentinrothberg@gmail.com>,
        Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <edubezval@gmail.com>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: thermal: exynos: Remove CONFIG_EXYNOS_THERMAL_CORE?
Message-id: <20150127110948.06a70f1c@amdc2363>
In-reply-to: <1422352605.14015.28.camel@x220>
References: <1422352605.14015.28.camel@x220>
Organization: SPRC Poland
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrLLMWRmVeSWpSXmKPExsVy+t9jAd2PycdDDHZf0bWYf+Uaq8XlXXPY
	LD73HmG0WHTrDLPFk4d9bBafmtuYHdg8ds66y+6xeM9LJo+N258weXzeJBfAEsVlk5Kak1mW
	WqRvl8CV8eT0AdaCR6wV9w/NZ2tgPM7SxcjJISFgIvFzyUJmCFtM4sK99WxdjFwcQgKLGCVe
	/57ABOH8YpTY+/IoI0gVi4CqxOH+k+wgNpuAnsTnu0+ZQGwRAWWJ1s332EEamAW2M0rM/fQR
	aBQHh7CAg8TevbkgNbxA9R//T2YHCXMK6Eo8WW8JEhYS0JGY3/qGFcTmF5CUaP/3A+ogO4lz
	nzawQ7QKSvyYfA/saGYBLYnN25pYIWx5ic1r3jJPYBSchaRsFpKyWUjKFjAyr2IUTS1ILihO
	Ss810itOzC0uzUvXS87P3cQIDvRn0jsYVzVYHGIU4GBU4uHdcPNYiBBrYllxZe4hRgkOZiUR
	Xq+I4yFCvCmJlVWpRfnxRaU5qcWHGKU5WJTEeZXs20KEBNITS1KzU1MLUotgskwcnFINjNLP
	oyJ+zpjlHzNz87Z7sifzJ10oO39x/xblKMt//wQl4twU1i3YmJIy9/WM6TkSpger+deq1ccI
	NqR883mcFRd75cXcaPmGN9eqtstwcv1VfF94+qfJdMMj5dUV9sFfcgWfOit8WmfLXaZR/HTG
	Z8ei9Vu2pIk0KC+oPx6oeOSN4LJ53/bkJSmxFGckGmoxFxUnAgBAWl0dcAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

> Lukasz,
> 
> Your commit 1fd2273f966a ("thermal: exynos: Remove
> exynos_thermal_common.[c|h] files") is included in today's linux-next
> (ie, next-20150127). I noticed because a script I use to check
> linux-next spotted a minor problem with it.
> 
> It removed the last users of CONFIG_EXYNOS_THERMAL_CORE. As a result
> setting the Kconfig symbol EXYNOS_THERMAL_CORE has no effect anymore.
> Is the trivial patch to remove that symbol's entry from
> drivers/thermal/samsung/Kconfig queued somewhere?

I will prepare appropriate patch and send it ASAP.

Thanks for hint.

> 
> 
> Paul Bolle
> 



-- 
Best regards,

Lukasz Majewski

Samsung R&D Institute Poland (SRPOL) | Linux Platform Group
