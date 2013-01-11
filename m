Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754604Ab3AKCA1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 21:00:27 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:63656 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753594Ab3AKCA0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 21:00:26 -0500
X-AuditID: cbfee61a-b7fa66d0000004cf-9c-50ef72382e75
Message-id: <50EF7238.1040408@samsung.com>
Date: Fri, 11 Jan 2013 11:00:24 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.2) Gecko/20120216
 Thunderbird/10.0.2
MIME-version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 09/11] extcon: arizona: Support HPDET based accessory
 identification
References: <20130110120231.GL20956@opensource.wolfsonmicro.com>
 <1357819462-12232-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <1357819462-12232-9-git-send-email-broonie@opensource.wolfsonmicro.com>
In-reply-to: <1357819462-12232-9-git-send-email-broonie@opensource.wolfsonmicro.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrCIsWRmVeSWpSXmKPExsVy+t8zbV2LovcBBrfvm1tc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6MZ52f2QtuMlbMPrOYuYFxMWMXIyeHhICJxIclr9kgbDGJC/fW
	A9lcHEICyxglZje8ZYYpWrPiNztEYhGjxM5fB6GcLiaJWdtXMIFU8QpoSUw4M40dxGYRUJVo
	ePYELM4GFN//4gbQWA4OUYEIiV/9HBDlghI/Jt9jAQmLAC34fb8SZCSzwGlGidaJ78CuExaI
	kjjZt4UVYtcVRol3F/+xgCQ4BcIk1t37zwpiMwvoSOxvncYGYctLbF4DcTWLgIDEt8mHwBZI
	CMhKbDrADDJHQqCZXeLPvDZ2iM8kJQ6uuMEygVFsFpKbZiEZOwvJ2AWMzKsYRVMLkguKk9Jz
	DfWKE3OLS/PS9ZLzczcxQqJCagfjygaLQ4wCHIxKPLyVmu8DhFgTy4orcw8xSnAwK4nwiqcB
	hXhTEiurUovy44tKc1KLDzH6AF07kVlKNDkfGLF5JfGGxgbGhoaWhmamlqYGOISVxHkZTz0J
	EBJITyxJzU5NLUgtghnHxMEp1cCo4bOgQupTGC9TUfn8A6WPJ4lPmvy7pOZCfOLmd8lc7fIl
	aZMn3eWuMPc7l3iLXUDD8Pm1D0aeFVdeTtq7M+b5gtlXmGY/vGEXtvDAPZ7iWubYxp8Pdq7k
	jV8onq7gvVZJ/PEOD70vBScEmJdfifuUM8u/Iqv1YtQU8Ys3ve+vlJi01/CofOoDJZbijERD
	Leai4kQAOWytf7cCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrMIsWRmVeSWpSXmKPExsVy+t9jAV2LovcBBvcn6Ftc3jWHzYHR4/Mm
	uQDGqAZGm4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE3FRbJRefAF23zByg
	qUoKZYk5pUChgMTiYiV9O0wTQkPcdC1gGiN0fUOC4HqMDNBAwjrGjGedn9kLbjJWzD6zmLmB
	cTFjFyMnh4SAicSaFb/ZIWwxiQv31rN1MXJxCAksYpTY+esgO4TTxSQxa/sKJpAqXgEtiQln
	poF1sAioSjQ8ewIWZwOK739xA6ibg0NUIELiVz8HRLmgxI/J91hAwiJAy37frwQZySxwmlGi
	deI7sCOEBaIkTvZtYYXYdYVR4t3FfywgCU6BMIl19/6zgtjMAjoS+1unsUHY8hKb17xlnsAo
	MAvJjllIymYhKVvAyLyKUTS1ILmgOCk911CvODG3uDQvXS85P3cTIzjmnkntYFzZYHGIUYCD
	UYmHt1LzfYAQa2JZcWXuIUYJDmYlEV7xNKAQb0piZVVqUX58UWlOavEhRh9gCExklhJNzgem
	g7ySeENjEzMjSyMzYxNzY2McwkrivIynngQICaQnlqRmp6YWpBbBjGPi4JRqYBRhOv6iTNZ7
	/bn9N+p1zxfEcSQnekXrXlGdP5G9pEW14WTw2W1rzDbsSHd7az25dUvT8oS+tQpaUVv1Tb/x
	Vtyr/C2hO9sq5x0Di6pDqpPH8zXPX8R5dZ2bP51/Wvmdu9os1l/niV/1MRT52dn45sgqF03v
	d89LVnox7fm4R+SiW3NG4eIXvkosxRmJhlrMRcWJAHEq2ZbmAgAA
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +		}
> +
> +		/* OK, got both.  Now, compare... */
Is is correct comment?

> +		dev_dbg(arizona->dev, "HPDET measured %d %d\n",
> +			info->hpdet_res[0], info->hpdet_res[1]);
> +

Thank you,
Chanwoo Choi
