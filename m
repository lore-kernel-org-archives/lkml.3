Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758069AbaJaKDT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 06:03:19 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:47493 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756003AbaJaKDR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 06:03:17 -0400
X-AuditID: cbfec7f4-b7f6c6d00000120b-4c-54535e625bf5
Message-id: <54535E60.4080802@samsung.com>
Date: Fri, 31 Oct 2014 11:03:12 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.1.2
MIME-version: 1.0
To: Kukjin Kim <kgene@kernel.org>
Cc: "'Chanwoo Choi'" <cw00.choi@samsung.com>, tomasz.figa@gmail.com,
        sw0312.kim@samsung.com, kyungmin.park@samsung.com,
        inki.dae@samsung.com, geunsik.lim@samsung.com,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mike Turquette <mturquette@linaro.org>
Subject: Re: [PATCHv3 0/2] clk: samsung: Add clock controller driver for
 Exynos4415 SoC
References: <1414372318-594-1-git-send-email-cw00.choi@samsung.com>
 <544E20E3.5030609@samsung.com> <02dd01cff265$0a846060$1f8d2120$@kernel.org>
In-reply-to: <02dd01cff265$0a846060$1f8d2120$@kernel.org>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrDLMWRmVeSWpSXmKPExsVy+t/xK7pJccEhBi9Wmltc//Kc1eLPhFY2
	i0n3J7BY9D9+zWxxtukNu8XlXXPYLGac38dk8XTCRSBr8ks2i1W7/jA6cHnsnHWX3WPTqk42
	jzvX9rB59G1ZxejxeZNcAGsUl01Kak5mWWqRvl0CV8aKKecYC+ZxVhz4f4K9gfEEexcjJ4eE
	gIlEz9MZULaYxIV769m6GLk4hASWMkqcXfaaFcL5xCgx8eh0ZpAqXgEtiWtfl4PZLAKqEmuu
	bQGz2QQMJXqP9jGC2KICERIn7+5hh6gXlPgx+R5LFyMHh4iAosTmBQogM5kFJjFJnDjZzwZS
	IywQKXFgXjsTxLKJjBJ7l3SDDeUUsJR4Ou0gK0gzs4CexP2LWiBhZgF5ic1r3jJPYBSYhWTF
	LISqWUiqFjAyr2IUTS1NLihOSs811CtOzC0uzUvXS87P3cQIiYEvOxgXH7M6xCjAwajEw7tC
	MjhEiDWxrLgy9xCjBAezkgiviDtQiDclsbIqtSg/vqg0J7X4ECMTB6dUA6NM5NxTGyUnPZx5
	ruZb4IHvZ+es/mvKlfJj10H3/XkB3f8XrDq7d/6GexdWlIrvzq2zaL/ubWCWceWA16SFJeeu
	pNwXa9A/9LaradtP9SU+bjnvldXVTxeU3GNeHcJVpeAlbxt2uG6GrEHy75wlXXkuJ2bHWU3r
	M9FcsaZTPWG17KNz8t9rg+cosRRnJBpqMRcVJwIAna6EUF8CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28/10/14 05:09, Kukjin Kim wrote:
> Sylwester Nawrocki wrote:
>>
>> On 27/10/14 02:11, Chanwoo Choi wrote:
>>> Chanwoo Choi (2):
>>>   clk: samsung: exynos4415: Add clocks using common clock framework
>>>   clk: samsung: Document binding for Exynos4415 clock controller
[...]
> 
> Can you please provide a topic branch for clk-exynos4415? Because exynos4415 dt
> file needs inclusion of following header files.
> 
> +#include <dt-bindings/clock/exynos4415.h>
> +#include <dt-bindings/clock/exynos-audss-clk.h>

Hi Kukjin,

AFAICS there is more clk patches that will be a dependency for the dts
changes, for instance recent exynos7 clock controller driver addition.
Unfortunately the patchset is written so almost every patch touches
header file at include/dt-bindings/clock/.

I'm inclined to send the collected exynos4415 and exynos7 patches to
Mike in a pull request and then he could make a topic branch which could
then be pulled as a dependency for dts.

Alternatively you could use my branch which can be found at:
git://linuxtv.org/snawrocki/samsung.git for-v3.19-exynos-clk

What would be your preference, Mike ?

-- 
Regards,
Sylwester
