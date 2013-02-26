Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758884Ab3BZBmM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 20:42:12 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:23482 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751366Ab3BZBmK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 20:42:10 -0500
X-AuditID: cbfee691-b7faa6d000005ae9-9f-512c12f03b29
From: Jingoo Han <jg1.han@samsung.com>
To: "'Tejun Heo'" <tj@kernel.org>
Cc: "'Andrew Morton'" <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, "'Greg KH'" <greg@kroah.com>,
        "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <008c01ce13bf$8d2cd550$a7867ff0$%han@samsung.com>
 <20130226012317.GF2679@htj.dyndns.org> <20130226013000.GG2679@htj.dyndns.org>
In-reply-to: <20130226013000.GG2679@htj.dyndns.org>
Subject: Re: [PATCH V2] rtc: add devm_rtc_device_{register,unregister}()
Date: Tue, 26 Feb 2013 10:42:07 +0900
Message-id: <008f01ce13c2$7c9e37d0$75daa770$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4TwM6IFjJLt402TMK+XtriEz4CRgAAVpvQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrJIsWRmVeSWpSXmKPExsVy+t8zQ90PQjqBBldfsVosuXiV3WLO+jVs
	FucWzGC0uLzwEqvF5V1z2Cz2d3YwWvxafpTRgd1jz8STbB6bVnWyebx9GOBxYsZvFo++LasY
	PabP+8nk8XmTXAB7FJdNSmpOZllqkb5dAlfGtqshBQvYKh6sjWtgfMbSxcjBISFgIvH3qVgX
	IyeQKSZx4d56ti5GLg4hgWWMEl9ut7BDJEwkfv3YCZWYziix++YHdgjnF1DVhb9gVWwCahJf
	vhwGs0UE5CWuPDkH1sEscINR4vOxCVAdvYwSk3c8Ywap4hQwlpj8ppUZ5A5hAQ+JL5/VQMIs
	AqoStw70soDYvAK2Ehs332KFsAUlfky+BxZnFtCSWL/zOBOELS+xec1bZoh31CUe/dWFuMFI
	4uzNnawQJSIS+168YwQ5QULgK7vE4jfL2CF2CUh8m3wIGhSyEpsOMEN8LClxcMUNlgmMErOQ
	bJ6FZPMsJJtnIVmxgJFlFaNoakFyQXFSepGpXnFibnFpXrpecn7uJkZINE/cwXj/gPUhxmSg
	9ROZpUST84HJIK8k3tDY2MTMxNTE3NLU3JQ0YSVxXvlLMoFCAumJJanZqakFqUXxRaU5qcWH
	GJk4OKUaGJsO98estX81d8+BdSd7gxPrlvXkSihOmDg/YvM+7t2rFsd4M/i4yl4w/KOy4MMx
	z7qO+wK7+QOO5lhZaNZv0rh4yPV0QHH49yyv8xPXsa7v/L5iTc3hwze1br+wd76TtHXmfu7m
	ELfo8o0nT0ucVb5j5ntMX7lp859P/dyFGk8Zyg+dcXn8L0uJpTgj0VCLuag4EQCbY66u/AIA	AA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrGKsWRmVeSWpSXmKPExsVy+t9jQd0PQjqBBr/tLJZcvMpuMWf9GjaL
	cwtmMFpcXniJ1eLyrjlsFvs7Oxgtfi0/yujA7rFn4kk2j02rOtk83j4M8Dgx4zeLR9+WVYwe
	0+f9ZPL4vEkugD2qgdEmIzUxJbVIITUvOT8lMy/dVsk7ON453tTMwFDX0NLCXEkhLzE31VbJ
	xSdA1y0zB+geJYWyxJxSoFBAYnGxkr4dpgmhIW66FjCNEbq+IUFwPUYGaCBhHWPGtqshBQvY
	Kh6sjWtgfMbSxcjJISFgIvHrx042CFtM4sK99UA2F4eQwHRGid03P7BDOL8YJb5c+MsOUsUm
	oCbx5cthMFtEQF7iypNzYB3MAjcYJT4fmwDV0csoMXnHM2aQKk4BY4nJb1qBbA4OYQEPiS+f
	1UDCLAKqErcO9IKdwStgK7Fx8y1WCFtQ4sfke2BxZgEtifU7jzNB2PISm9e8BRsjIaAu8eiv
	LsQNRhJnb+5khSgRkdj34h3jBEahWUgmzUIyaRaSSbOQtCxgZFnFKJpakFxQnJSea6RXnJhb
	XJqXrpecn7uJEZwqnknvYFzVYHGIUYCDUYmHV6NDO1CINbGsuDL3EKMEB7OSCC9nBlCINyWx
	siq1KD++qDQntfgQYzLQoxOZpUST84FpLK8k3tDYxMzI0sjMwsjE3Jw0YSVxXsZTTwKEBNIT
	S1KzU1MLUotgtjBxcEo1MMrOcXbv/uX7eGXA0mfbm/oeSnDvW3JGL6nhmG3wxil/LGedZz24
	Za2ZQ+UK4TvzY6+zWb2elvV/i9a7ZdfTVGfsEW6U7PZ7l5or+5bvyRJ+t8hPvVFW5TNbH3iK
	pj24duvG+ZPNe/bwe9Q6MjxizGyXW2ST7ODt6tVgrTAtMmpy1NF9lb/m5imxFGckGmoxFxUn
	AgBfJOdOWQMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, February 26, 2013 10:30 AM, Tejun Heo wrote:
> 
> On Mon, Feb 25, 2013 at 05:23:17PM -0800, 'Tejun Heo' wrote:
> > again, why do we need the WARN_ON() at all given that other
> > devm_*_match() don't do that and the only way to get NULL there would
> > be bug in devm_rtc*() code itself rather than its users?
> 
> Ughh... I see that you probably copied the chunk from clk / regulator
> implementation.  Let's please not copy those.  Input validation via
> WARN_ON()s is nice when the interface is taking input from outside or
> the code in question is complex / fragile.  Here, the code involved is
> like 20 lines and self-contained.

OK, I see.
Thank you for your comment.
I will send v3 patch soon :)

Best regards,
Jingoo Han

> 
> Thanks.
> 
> --
> tejun

