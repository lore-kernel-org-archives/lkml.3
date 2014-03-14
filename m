Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755578AbaCNRwQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 13:52:16 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:53670 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753709AbaCNRwM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 13:52:12 -0400
X-AuditID: cbfec7f5-b7fc96d000004885-ee-532341c83141
Message-id: <532341C7.8070407@samsung.com>
Date: Fri, 14 Mar 2014 18:52:07 +0100
From: Tomasz Figa <t.figa@samsung.com>
Organization: Samsung R&D Institute Poland
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.3.0
MIME-version: 1.0
To: Chanwoo Choi <cw00.choi@samsung.com>, myungjoo.ham@samsung.com,
        kyungmin.park@samsung.com
Cc: rafael.j.wysocki@intel.com, nm@ti.com, b.zolnierkie@samsaung.com,
        pawel.moll@arm.com, mark.rutland@arm.com, swarren@wwwdotorg.org,
        ijc+devicetree@hellion.org.uk, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCHv2 6/8] devfreq: exynos4: Fix power-leakage of clock on
 suspend state
References: <1394698649-20996-1-git-send-email-cw00.choi@samsung.com>
 <1394698649-20996-7-git-send-email-cw00.choi@samsung.com>
In-reply-to: <1394698649-20996-7-git-send-email-cw00.choi@samsung.com>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpgkeLIzCtJLcpLzFFi42I5/e/4Vd0TjsrBBi2/rS06en6zWFz/8pzV
	Yv6Rc6wW516tZLQ42/SG3WJh2xIWi8u75rBZfO49wmgx4/w+Joul1y8yWdxuXMFm8ebHWSaL
	CdPXslg8XvGW3eLVwTYWB36PNfPWMHqsXP6FzWPxnpdMHj+Xb2f36NuyitHj+I3tTB6fN8l5
	bJwbGsARxWWTkpqTWZZapG+XwJWxfPcp1oIDTBUfGq6xNDD+Y+xi5OSQEDCRuDHvGAuELSZx
	4d56ti5GLg4hgaWMEnsvdrGCJIQEPjNKLOnLALF5BbQk3i7dCBZnEVCV+Dd9Nlgzm4CaxOeG
	R2wgNj9QzZqm62BxUYEIibkTN7NB9ApK/Jh8DyjOwSEiEC9x8ZMgyC5mgX1MEl9m/GYHqREW
	iJJ4f+0fK8QRjYwSky6uAhvEKeAmcWDmJiYQm1nAWmLlpG2MELa8xOY1b5knMArOQrJjFpKy
	WUjKFjAyr2IUTS1NLihOSs810itOzC0uzUvXS87P3cQIibWvOxiXHrM6xCjAwajEw6uhqhws
	xJpYVlyZe4hRgoNZSYR3vzFQiDclsbIqtSg/vqg0J7X4ECMTB6dUA+PpTYxuh7jXbljWsTz3
	2pezmz6JHd/Xnt0ktupw6/9WyWDZs5O8hF6mLDy6foNVyx+3iKsVEhIHRJYkiuyW21z/8F7+
	aaujxqGCl6ZXBJpZcodv6/suU3UifMWTtL1b6jXnm5euNypSFlIsvmPi80v9aKDdk/8zrHVW
	PWJ/tUx3l8eVGVeyLJ4psRRnJBpqMRcVJwIAr9AYEJMCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chanwoo,

On 13.03.2014 09:17, Chanwoo Choi wrote:
> This patch disable ppmu clocks before entering suspend state to remove
> power-leakage and enable ppmu clocks on resume function.

I don't think there is any need for this, because all the clocks are 
stopped anyway in SLEEP mode.

Best regards,
Tomasz
