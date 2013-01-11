Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754641Ab3AKB6t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 20:58:49 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:51844 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754542Ab3AKB6q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 20:58:46 -0500
X-AuditID: cbfee61b-b7f616d00000319b-37-50ef71c42aa7
Message-id: <50EF71C3.6060009@samsung.com>
Date: Fri, 11 Jan 2013 10:58:27 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.2) Gecko/20120216
 Thunderbird/10.0.2
MIME-version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/11] extcon-arizona updates
References: <20130110120231.GL20956@opensource.wolfsonmicro.com>
In-reply-to: <20130110120231.GL20956@opensource.wolfsonmicro.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrEIsWRmVeSWpSXmKPExsVy+t8zXd0jhe8DDLqeKVtc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6MtmPP2Ap+ClWc7vvN1sA4k7+LkZNDQsBE4uKrFkYIW0ziwr31
	bF2MXBxCAssYJTb2TmSFKWr/e44ZIjGdUeL8i71MEE4Xk8THz//A2nkFtCRurW8As1kEVCVu
	fPrODGKzAcX3v7gBNJaDQ1QgQuJXPwdEuaDEj8n3WEDCIkALft+vBBnJLHCaUaJ14juwMcIC
	BhIH1p1lAqkREnCQ+DhfFCTMKeAo8WLNGbASZgEdif2t09ggbHmJzWveMkNcICDxbfIhsPES
	ArISmw6AnS8h0Mwu8fTIVHaIvyQlDq64wTKBUWwWkotmIRk7C8nYBYzMqxhFUwuSC4qT0nON
	9IoTc4tL89L1kvNzNzFCIkJ6B+OqBotDjAIcjEo8vJWa7wOEWBPLiitzDzFKcDArifCKpwGF
	eFMSK6tSi/Lji0pzUosPMfoAXTuRWUo0OR8YrXkl8YbGBsaGhpaGZqaWpgY4hJXEeRlPPQkQ
	EkhPLEnNTk0tSC2CGcfEwSnVwNi5grlEoK0lbvHcZnW/ZVNv9d3TZeC2jXjEw3bo2SdRW4m4
	ffIhjLua2Kade8qp8I23UdtLNGrunc2/frbtuWa1XKZf8nunO8vMn/de7d6uGfU0wjOvRZgn
	2+mojszhM+tEK36/WLsl4seV9cd9ZjxNeDhlkfpL48+rfXvVwsyczhwUsO9fFK7EUpyRaKjF
	XFScCACUl1HytQIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrIIsWRmVeSWpSXmKPExsVy+t9jQd0jhe8DDJb8l7S4vGsOmwOjx+dN
	cgGMUQ2MNhmpiSmpRQqpecn5KZl56bZK3sHxzvGmZgaGuoaWFuZKCnmJuam2Si4+AbpumTlA
	U5UUyhJzSoFCAYnFxUr6dpgmhIa46VrANEbo+oYEwfUYGaCBhHWMGW3HnrEV/BSqON33m62B
	cSZ/FyMnh4SAiUT733PMELaYxIV769m6GLk4hASmM0qcf7GXCcLpYpL4+PkfI0gVr4CWxK31
	DWA2i4CqxI1P38G62YDi+1/cAOrm4BAViJD41c8BUS4o8WPyPRaQsAjQst/3K0FGMgucZpRo
	nfgObIywgIHEgXVnmUBqhAQcJD7OFwUJcwo4SrxYcwashFlAR2J/6zQ2CFteYvOat8wTGAVm
	IdkwC0nZLCRlCxiZVzGKphYkFxQnpeca6RUn5haX5qXrJefnbmIEx9sz6R2MqxosDjEKcDAq
	8fBWar4PEGJNLCuuzD3EKMHBrCTCK54GFOJNSaysSi3Kjy8qzUktPsToA/T/RGYp0eR8YCrI
	K4k3NDYxM7I0MjM2MTc2xiGsJM7LeOpJgJBAemJJanZqakFqEcw4Jg5OqQbGXt6rbep6Z49H
	pCjU1le/MUs/PV8/89OVs3MylGSNjxx69zzjzJzl3yL2dwWtuiL9RGP9x26b3ZsFHU9HT6px
	3vdpj9X++ALGE5+0zOovXrErXNQiMs3gyXGhU0Xrp0kUCGv3KxZVLK57cT3SeMq9s6wMfHUH
	Wqddcux8wpjjrdZ9YMHRg5VTlViKMxINtZiLihMB+RWfVeQCAAA=
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/10/2013 09:02 PM, Mark Brown wrote:
> The following changes since commit 9931faca02c604c22335f5a935a501bb2ace6e20:
> 
>   Linux 3.8-rc3 (2013-01-09 18:59:55 -0800)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/broonie/misc.git tags/extcon-arizona-3.8rc3
> 
> for you to fetch changes up to 708f5b582ea16b60701e275fe5233ec4c57859cd:
> 
>   mfd: wm5102: Add microphone clamp control registers (2013-01-10 11:35:42 +0000)
> 
> ----------------------------------------------------------------
> extcon: arizona: Updates to arizona extcon driver
> 
> This patch series adds a number of new features to the arizona driver:
> 
>  - Headphone measurements.
>  - Alternative detection mechanism for non-default system designs.
>  - Microphone clamp integration.
>  - Support for additional detection pin.
>  - MICBIAS rise time configuration.
> 
> There's one trivial MFD patch which is here because it depends on
> register definitions from the new features.
> 
> ----------------------------------------------------------------
> Mark Brown (11):
>       extcon: arizona: Convert to devm_input_allocate_device()
>       extcon: arizona: Remove duplicate mic ramp configuration
>       extcon: arizona: Only set GPIO if it has been requested
>       extcon: arizona: Allow configuration of MICBIAS rise time
>       extcon: arizona: Use microphone clamp function if available
>       extcon: arizona: Support use of GPIO5 as an input to jack detection
>       extcon: arizona: Enable basic headphone identification
>       extcon: arizona: Move start and stop mic functions earlier
>       extcon: arizona: Support HPDET based accessory identification
>       extcon: arizona: Support direct microphone measurement via HPDET
>       mfd: wm5102: Add microphone clamp control registers
> 
>  drivers/extcon/extcon-arizona.c       |  634 ++++++++++++++++++++++++++++++---
>  drivers/mfd/wm5102-tables.c           |   10 +
>  include/linux/mfd/arizona/core.h      |    4 +-
>  include/linux/mfd/arizona/pdata.h     |   12 +
>  include/linux/mfd/arizona/registers.h |   48 +++
>  5 files changed, 658 insertions(+), 50 deletions(-)

Applied this patch set.

You can check this on extcon git repository:
http://git.kernel.org/?p=linux/kernel/git/chanwoo/extcon.git;a=shortlog;h=refs/heads/for-next

Thank you,
Chanwoo Choi

