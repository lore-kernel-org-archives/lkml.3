Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752721AbaBJPyZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 10:54:25 -0500
Received: from mail-pd0-f172.google.com ([209.85.192.172]:51522 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752667AbaBJPyV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 10:54:21 -0500
Message-ID: <52F8F629.7040006@intel.com>
Date: Mon, 10 Feb 2014 07:54:17 -0800
From: Dirk Brandewie <dirk.brandewie@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Fengguang Wu <fengguang.wu@intel.com>
CC: dirk.j.brandewie@intel.com,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        LKML <linux-kernel@vger.kernel.org>, lkp@01.org
Subject: Re: [intel_pstate] fcb6a15c: -34.4% aim7 jobs-per-min and -17.0%
 will-it-scale/page_fault1 Pkg_W
References: <20140207123315.GA3448@localhost>
In-Reply-To: <20140207123315.GA3448@localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/07/2014 04:33 AM, Fengguang Wu wrote:
> Hi Dirk,
>
> FYI, we notice dropped power and performance numbers on commit
> fcb6a15c2e7e76d493e6f91ea889ab40e1c643a4 ("intel_pstate: Take core C0
> time into account for core busy calculation").
>
>
>        v3.14-rc1  fcb6a15c2e7e76d493e6f91ea
> ---------------  -------------------------
>        6.53 ~ 4%     -12.0%       5.75 ~ 2%  lkp-sb03/micro/netperf/120s-200%-SCTP_STREAM
>      147.93 ~ 0%     -23.3%     113.40 ~ 0%  lkp-sbx04/micro/will-it-scale/page_fault1
>      154.46 ~ 0%     -22.9%     119.15 ~ 0%  TOTAL turbostat.Cor_W
>
>        v3.14-rc1  fcb6a15c2e7e76d493e6f91ea
> ---------------  -------------------------
>         203 ~ 0%     -17.0%        169 ~ 0%  lkp-sbx04/micro/will-it-scale/page_fault1
>         203 ~ 0%     -17.0%        169 ~ 0%  TOTAL turbostat.Pkg_W
>

These two tests show an improvement in power :-)

>        v3.14-rc1  fcb6a15c2e7e76d493e6f91ea
> ---------------  -------------------------
>      572540 ~ 1%     -30.2%     399351 ~ 1%  grantley/micro/aim7/disk_src
>      317151 ~ 1%     -42.0%     183863 ~ 0%  grantley/micro/aim7/shell_rtns_1
>      889692 ~ 1%     -34.4%     583214 ~ 1%  TOTAL aim7.2000.jobs-per-min
>

I am investigating where the aim benchmark went south.



