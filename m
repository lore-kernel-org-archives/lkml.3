Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756349AbaFYLmM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 07:42:12 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:50347 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751598AbaFYLmK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 07:42:10 -0400
X-AuditID: cbfec7f5-b7f626d000004b39-34-53aab58fefe5
Message-id: <53AAB577.4010009@samsung.com>
Date: Wed, 25 Jun 2014 13:41:43 +0200
From: Tomasz Figa <t.figa@samsung.com>
Organization: Samsung R&D Institute Poland
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.5.0
MIME-version: 1.0
To: Daniel Drake <drake@endlessm.com>
Cc: linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Kukjin Kim <kgene.kim@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>
Subject: Re: [PATCH 4/6] ARM: SAMSUNG: Restore Samsung PM Debug functionality
References: <1403618235-19353-1-git-send-email-t.figa@samsung.com>
 <1403618235-19353-5-git-send-email-t.figa@samsung.com>
 <CAD8Lp46GpaGzq+2bkyujRtSVYJt7PWWT47NvjifoxzJk7aKs6A@mail.gmail.com>
In-reply-to: <CAD8Lp46GpaGzq+2bkyujRtSVYJt7PWWT47NvjifoxzJk7aKs6A@mail.gmail.com>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrJLMWRmVeSWpSXmKPExsVy+t/xy7r9W1cFG0z6L2DxaP5jZoveBVfZ
	LDY9vsZqcXnXHDaLGef3MVmsPXKX3WLVrj+MDuwei75neeycdZfdY/OSeo++LasYPT5vkgtg
	jeKySUnNySxLLdK3S+DKOPHxI1vBNLaKD3vbWBoYG1m7GDk5JARMJBbfe8kIYYtJXLi3nq2L
	kYtDSGApo8SXGc2MEM5nRolJ07ewgFTxCmhJ/Pk0kRnEZhFQlTi45SMTiM0moCbxueERG4jN
	D1Szpuk6UD0Hh6hAhMTjC0IQrYISPybfAxsjAtT6a3kzK8h8ZoHfjBLTr84Dmyks4CuxqX0b
	1BWHGCXOtf8BG8opECwxZfkWsGXMAuoSk+YtYoaw5SU2r3nLPIFRcBaSJbOQlM1CUraAkXkV
	o2hqaXJBcVJ6rpFecWJucWleul5yfu4mRkjwf93BuPSY1SFGAQ5GJR7eAJ5VwUKsiWXFlblA
	13AwK4nw1m8ACvGmJFZWpRblxxeV5qQWH2Jk4uCUamCcwqo8Q3tR068Mj3S+ngfPFlxaU214
	5bXp+m/83pLHoyee8v/M7KdnuSE65/z/tXavFGYe/7EtQCnD171S6cCC7o3KXcXydenOm3xv
	3pEOWq1X8ye66+yb01J2Hx2mac88e/zUUiujn68v/z9yxHTKS3tm9ryo8zqCO5kVco33rFZ8
	kfr/lGy5EktxRqKhFnNRcSIAP3iSjVwCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25.06.2014 12:09, Daniel Drake wrote:
> Hi Tomasz,
> 
> On Tue, Jun 24, 2014 at 2:57 PM, Tomasz Figa <t.figa@samsung.com> wrote:
>> Due to recently merged patches and previous merge conflicts, the Samsung
>> PM Debug functionality no longer can be enabled. This patch fixes
>> incorrect dependency of SAMSUNG_PM_DEBUG on an integer symbol and adds
>> missing header inclusion.
> 
> Testing against 3.16-rc2, this doesn't quite work for me.
> SAMSUNG_PM_DEBUG still doesn't appear in menuconfig.
> 
> HAVE_SAMSUNG_PM_DEBUG is 'n'. Looks like the select from
> DEBUG_S3C_UART is not working, but I'm not sure why.

I hastily changed this to something simpler in last minute before
sending without proper testing. Let me send something that works.

Best regards,
Tomasz
