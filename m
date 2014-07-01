Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752023AbaGAG2E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 02:28:04 -0400
Received: from mail-lb0-f181.google.com ([209.85.217.181]:63112 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751269AbaGAG2D convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 02:28:03 -0400
MIME-Version: 1.0
In-Reply-To: <20140630133712.GU3679@tbergstrom-lnx.Nvidia.com>
References: <1404121254-23823-1-git-send-email-sachin.kamat@samsung.com>
	<20140630133712.GU3679@tbergstrom-lnx.Nvidia.com>
Date: Tue, 1 Jul 2014 11:58:00 +0530
X-Google-Sender-Auth: Vv0sLx8DfYvxiwq0r7P6ND0EPGw
Message-ID: <CAK5sBcEDmhjqoDM-ezs8DxpdEw4wv9m7uisFjHwSoRHe0bE99w@mail.gmail.com>
Subject: Re: [PATCH 1/1] clk: Fix build warnings
From: Sachin Kamat <sachin.kamat@samsung.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mturquette@linaro.org" <mturquette@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 30, 2014 at 7:07 PM, Peter De Schrijver
<pdeschrijver@nvidia.com> wrote:
> On Mon, Jun 30, 2014 at 11:40:54AM +0200, Sachin Kamat wrote:
>> ‘all_lists’ and ‘orphan_list’ is accessed only when DEBUG_FS is defined.
>> Thus, make their compilation conditional to fix the below warnings introduced
>> by commit 27b8d5f723 ("clk: flatten clk tree in debugfs"):
>> drivers/clk/clk.c:40:27: warning: ‘all_lists’ defined but not used [-Wunused-variable]
>> drivers/clk/clk.c:46:27: warning: ‘orphan_list’ defined but not used [-Wunused-variable]
>>
>
> Maybe just move them inside the existing #ifdef CONFIG_DEBUG_FS / #endif?

That makes sense. Thanks for the hint. Will re-spin.

Regards,
Sachin.
