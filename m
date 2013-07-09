Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753564Ab3GIH5L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 03:57:11 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:27194 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753539Ab3GIH5G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 03:57:06 -0400
X-AuditID: cbfee691-b7fef6d000002d62-78-51dbc250f170
Message-id: <51DBC24F.5040202@samsung.com>
Date: Tue, 09 Jul 2013 16:57:03 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: rjw@sisk.pl, linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        cpufreq@vger.kernel.org, kyungmin.park@samsung.com,
        myungjoo.ham@samsung.com
Subject: Re: [PATCH 0/6] cpufreq: Add 'load_table' debugfs file to show
 colleced CPUs load
References: <1373014001-17746-1-git-send-email-cw00.choi@samsung.com>
 <CAKohpokzn4jrO3rr8pjzwd4Xn+0umOK-sMANV2Fj5xn6UhBHVg@mail.gmail.com>
In-reply-to: <CAKohpokzn4jrO3rr8pjzwd4Xn+0umOK-sMANV2Fj5xn6UhBHVg@mail.gmail.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrBIsWRmVeSWpSXmKPExsWyRsSkWDfg0O1Ag/+HFCyeNv1gtzjb9Ibd
	4vKuOWwWn3uPMFrcblzBZtG/sJfJYuNXDwd2jzvX9rB59G1ZxejxaHELo8fnTXIBLFFcNimp
	OZllqUX6dglcGfsXixU85qk4d2caSwPjKa4uRk4OCQETiZYpN5kgbDGJC/fWs3UxcnEICSxl
	lDjc2sIOU7Sl8TMjRGIRo8Smq49YIZxXjBLrt09iA6niFdCSePz9KAuIzSKgKvHw/WGwbjag
	+P4XN8BqRAXCJFZOv8ICUS8o8WPyPSCbg0MEqOblzVSQmcwC0xklpv/YxQxSIywQI7H88Tew
	eiGBHkaJBafEQWxOgWCJSS+esoLYzAI6Evtbp7FB2PISm9e8ZQYZJCFwil1i8992VoiDBCS+
	TT4EtkxCQFZi0wFmiM8kJQ6uuMEygVFsFpKTZiEZOwvJ2AWMzKsYRVMLkguKk9KLTPWKE3OL
	S/PS9ZLzczcxAmPt9L9nE3cw3j9gfYgxGWjlRGYp0eR8YKzmlcQbGpsZWZiamBobmVuakSas
	JM6r3mIdKCSQnliSmp2aWpBaFF9UmpNafIiRiYNTqoGRNX5Zh4BPDEO0lNeqwy9k72odupTE
	spVV8QpzbYZxYV13xYRtikaflh+6qfFnA/eVjkyPQ9vcNp5jzFonFbjNouT/9+LIZbU8s096
	CC+7zH104lKPuQ/Ku1/1LHtu6ZJ5SHs/o+Bd7+2RL9oTE44/VL16Pv5SMf/75aekdMs99X5u
	MghjyHinxFKckWioxVxUnAgA8NiUGssCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprKKsWRmVeSWpSXmKPExsVy+t9jAd2AQ7cDDW6/krB42vSD3eJs0xt2
	i8u75rBZfO49wmhxu3EFm0X/wl4mi41fPRzYPe5c28Pm0bdlFaPHo8UtjB6fN8kFsEQ1MNpk
	pCampBYppOYl56dk5qXbKnkHxzvHm5oZGOoaWlqYKynkJeam2iq5+AToumXmAF2gpFCWmFMK
	FApILC5W0rfDNCE0xE3XAqYxQtc3JAiux8gADSSsYczYv1is4DFPxbk701gaGE9xdTFyckgI
	mEhsafzMCGGLSVy4t56ti5GLQ0hgEaPEpquPWCGcV4wS67dPYgOp4hXQknj8/SgLiM0ioCrx
	8P1hdhCbDSi+/8UNsBpRgTCJldOvsEDUC0r8mHwPyObgEAGqeXkzFWQms8B0RonpP3Yxg9QI
	C8RILH/8DaxeSKCHUWLBKXEQm1MgWGLSi6esIDazgI7E/tZpbBC2vMTmNW+ZJzAKzEKyYhaS
	sllIyhYwMq9iFE0tSC4oTkrPNdIrTswtLs1L10vOz93ECI7kZ9I7GFc1WBxiFOBgVOLh/XD5
	VqAQa2JZcWXuIUYJDmYlEd5FO28HCvGmJFZWpRblxxeV5qQWH2JMBobARGYp0eR8YJLJK4k3
	NDYxM7I0Mje0MDI2J01YSZz3YKt1oJBAemJJanZqakFqEcwWJg5OqQbG3HU1QRUztkg/cm45
	tuT/5X/tbWs9eg8GTeQNVXsnVFb30WC/8tJnv+vmOj9gFGd769xXffeeTT5Do8gfr4evV06U
	2XJEtkjpH9e2nSnAaFRamBoibrtKS3hF5CMpi6J3bwq0J9n42M40P+nF93P/x/1/C3MTyhtm
	fYrZMiPV2mxehWf3rqtKLMUZiYZazEXFiQAK61bgKAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/09/2013 03:50 PM, Viresh Kumar wrote:
> On 5 July 2013 14:16, Chanwoo Choi <cw00.choi@samsung.com> wrote:
>> Second, previous performance/powersave governor haven't calculated CPUs load
>> becuase these governor didn't change CPU frequency according to CPUs load. But,
>> load_table debugfs file always should indicate the collected CPUs data regardless
>> of the kind of cpufreq governor. So, the patch3/4/5 implement that performance/
>> powersave governor will check periodically CPUs load by calling dbs_check_cpu()
>> with timer.
> 
> I raised a query on how can we call dbs_check_cpu() from
> performance/powersave? Also, calling this routine will degrade
> performance without any sense. So, I vote not for doing it.

You're right. The performance/powersave don't usually need calling operation
of dbs_check_cpu(). Only, this patch aims at checking CPUs load on
load_table debugfs file.

I'm going to consider more efficient way than this patchset.
For example, 

But, following patctes haven't the dependency about upper description about performance/powersave.
If user changes cpufreq governor from ondemand/conservative to performance/powersave,
patch2 did reset all of the data for load_table.

  cpufreq: Add debugfs directory for cpufreq
  cpufreq: stats: Add 'load_table' debugfs file to show accumulated data of CPUs
  Documentation: cpufreq: load_table: Update load_table debugfs file documentation

So, I'd like you to review patch1,patch2, patch6. If you with that I resend patch1/2/6,
I will resend new patchset incluing in patch1/2/6.

Thanks,

Best Regards,
Chanwoo Choi

