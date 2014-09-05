Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752751AbaIEG0s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 02:26:48 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:62148 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751066AbaIEG0q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 02:26:46 -0400
Message-ID: <54095835.7000207@gmail.com>
Date: Fri, 05 Sep 2014 08:29:09 +0200
From: Francis Moreau <francis.moro@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Brian Norris <computersforpeace@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: stable@vger.kernel.org, linux-pm@vger.kernel.org,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: Re: [PATCH 3.10.y+] PM / sleep: Use valid_state() for platform-dependent
 sleep states only
References: <1849024.CHOUso6H2K@vostro.rjw.lan> <1409865665-5375-1-git-send-email-computersforpeace@gmail.com>
In-Reply-To: <1409865665-5375-1-git-send-email-computersforpeace@gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 09/04/2014 11:21 PM, Brian Norris wrote:
> From: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
> 
> [Upstream commit 43e8317b0bba1d6eb85f38a4a233d82d7c20d732]
> 
> Use the observation that, for platform-dependent sleep states
> (PM_SUSPEND_STANDBY, PM_SUSPEND_MEM), a given state is either
> always supported or always unsupported and store that information
> in pm_states[] instead of calling valid_state() every time we
> need to check it.
> 
> Also do not use valid_state() for PM_SUSPEND_FREEZE, which is always
> valid, and move the pm_test_level validity check for PM_SUSPEND_FREEZE
> directly into enter_state().
> 
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Cc: <stable@vger.kernel.org> # 3.10+: 27ddcc6596e5: PM / sleep: Add state field to pm_states[] entries
> Cc: <stable@vger.kernel.org> # 3.10+
> ---
> This is a backport request for these two commits upstream:
> 
>     27ddcc6596e5 PM / sleep: Add state field to pm_states[] entries
>     43e8317b0bba PM / sleep: Use valid_state() for platform-dependent sleep states only
> 

Wouldn't it be cleaner to have 2 separate backports then ?

Thanks for the backport anyways.

