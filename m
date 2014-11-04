Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752511AbaKDLEp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 06:04:45 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:60498 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750727AbaKDLEk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 06:04:40 -0500
X-AuditID: cbfec7f5-b7f956d000005ed7-e9-5458b2c5f56f
Message-id: <1415099076.7941.14.camel@AMDC1943>
Subject: Re: [PATCH v4 00/14] Add max77802 regulator operating mode support
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Cc: Mark Brown <broonie@kernel.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>, Olof Johansson <olof@lixom.net>,
        Chris Zhong <zyw@rock-chips.com>,
        Abhilash Kesavan <kesavan.abhilash@gmail.com>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Date: Tue, 04 Nov 2014 12:04:36 +0100
In-reply-to: <5458AF9D.1080201@collabora.co.uk>
References: <1415025649-8119-1-git-send-email-javier.martinez@collabora.co.uk>
 <1415097899.7941.10.camel@AMDC1943> <5458AF9D.1080201@collabora.co.uk>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.10.4-0ubuntu2
MIME-version: 1.0
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrCLMWRmVeSWpSXmKPExsVy+t/xy7pHN0WEGFx6ZWEx9eETNovrX56z
	Wsw/co7V4ujvAos1f5UsehdcZbO4vGsOm8WM8/uYLE5d/8xmMf/BDmYHLo+/z6+zeOycdZfd
	Y9OqTjaPKyeaWD3+ztrP4tG3ZRWjx+dNcgHsUVw2Kak5mWWpRfp2CVwZmxZvZyvYwFLx8fAd
	tgbGDcxdjJwcEgImEld+PmSHsMUkLtxbzwZiCwksZZSYfaigi5ELyP7MKLH7+QImkASvgL7E
	2r1TgGwODmEBb4mf77RBwmwCxhKbly8B6xURsJO4sfohM0gvs8AxJomZq9axgCRYBFQlOncs
	AyviBJqz9GsbI8SC6YwSa58tB7uCWUBdYtK8RcwgCyQElCUa+90g9gpK/Jh8jwWiRF5i85q3
	zBMYBWYh6ZiFpGwWkrIFjMyrGEVTS5MLipPSc430ihNzi0vz0vWS83M3MUJi4usOxqXHrA4x
	CnAwKvHwroiPCBFiTSwrrsw9xCjBwawkwru6CijEm5JYWZValB9fVJqTWnyIkYmDU6qBkdNh
	hfH+c6evRGx7/fzwqZKZH0za5JvOWps/2Rm6amHVRUGB9+ulvUUa1f3u6SXeMF0iwBvE8+Xp
	x72NE6NzfXjKdupLbZWz9XmWmTTTlLmf73jT5H87tD3+sT4P5lpvueX2uT99t/krY2a4fbv8
	bXVtcatk4LIjG759+CDqp7gg7PH8kHd8M5VYijMSDbWYi4oTAf+IumJnAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On wto, 2014-11-04 at 11:51 +0100, Javier Martinez Canillas wrote:
> Hello Krzysztof,
> 
> On 11/04/2014 11:44 AM, Krzysztof Kozlowski wrote:
> > 
> > Where's a diff stat? It is helpful to see what files were touched and I
> > believe it is created by default with format-patch.
> >
> 
> Yes, I removed the diffstat since it was quite big due the drivers
> refactor and the cover letter was already long but I'll add it in
> the next revision.

I was searching for regulator.h and I hope to find it in diffstat...

Best regards,
Krzysztof


