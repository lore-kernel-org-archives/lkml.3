Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751897AbaKGG0q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 01:26:46 -0500
Received: from mail-la0-f52.google.com ([209.85.215.52]:51900 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751555AbaKGG0o convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 01:26:44 -0500
MIME-Version: 1.0
In-Reply-To: <20141107060040.GD30507@yliu-dev.sh.intel.com>
References: <20141107060040.GD30507@yliu-dev.sh.intel.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 6 Nov 2014 22:26:23 -0800
Message-ID: <CALCETrVBcZ=5YJMzjKwFpjz6p32FmXcdkR=8uSPm8kCECDka4g@mail.gmail.com>
Subject: Re: [LKP] [x86_64,entry] f04e05b81e4: -62.7% time.user_time
To: LKP <lkp@01.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Yuanhan Liu <yuanhan.liu@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 6, 2014 at 10:00 PM, LKP <lkp@01.org> wrote:
> FYI, we noticed the below changes on
>
> git://git.kernel.org/pub/scm/linux/kernel/git/luto/linux.git x86/entry
> commit f04e05b81e4d9ae88bee379f12176f551a24394a ("x86_64,entry: Use sysret to return to userspace when possible")
>
>
> f2ee9bebb99dd4a4  f04e05b81e4d9ae88bee379f12  testbox/testcase/testparams
> ----------------  --------------------------
>          %stddev     %change         %stddev
>              \          |                \
>      24.09 ±  4%     -62.7%       8.99 ±  3%  lkp-wsx02/aim9/performance-300s-creat-clo
>      24.09           -62.7%       8.99        GEO-MEAN time.user_time
>

I don't really know how to interpret this.  Is this a good thing or a bad thing?

I actually expect this change to be a dramatic speedup for some
workloads.  Any chance you can send me the .config, kernel command
line, and whether you have any tracing features enabled?

--Andy
