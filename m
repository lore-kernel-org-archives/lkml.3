Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752222AbaBZCjs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 21:39:48 -0500
Received: from mail-pb0-f49.google.com ([209.85.160.49]:38171 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751579AbaBZCjq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 21:39:46 -0500
Message-ID: <530D53EF.9090706@amacapital.net>
Date: Tue, 25 Feb 2014 18:39:43 -0800
From: Andy Lutomirski <luto@amacapital.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: "Yan, Zheng" <zheng.z.yan@intel.com>, linux-kernel@vger.kernel.org
CC: a.p.zijlstra@chello.nl, mingo@kernel.org, acme@infradead.org,
        eranian@google.com, andi@firstfloor.org
Subject: Re: [PATCH v3 00/14] perf, x86: Haswell LBR call stack support
References: <1392703661-15104-1-git-send-email-zheng.z.yan@intel.com>
In-Reply-To: <1392703661-15104-1-git-send-email-zheng.z.yan@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/17/2014 10:07 PM, Yan, Zheng wrote:
> 
> This patch series adds LBR call stack support. User can enabled/disable
> this through an sysfs attribute file in the CPU PMU directory:
>  echo 1 > /sys/bus/event_source/devices/cpu/lbr_callstack 

This seems like an unpleasant way to control this.  It would be handy to
be able to control this as an option to perf record.

--Andy
