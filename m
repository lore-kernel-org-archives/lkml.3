Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752860Ab3JLRcj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Oct 2013 13:32:39 -0400
Received: from terminus.zytor.com ([198.137.202.10]:37623 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752606Ab3JLRci (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Oct 2013 13:32:38 -0400
Message-ID: <52598770.6090309@zytor.com>
Date: Sat, 12 Oct 2013 10:31:28 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: mingo@kernel.org, linux-kernel@vger.kernel.org, tglx@linutronix.de,
        d.hatayama@jp.fujitsu.com, hpa@linux.intel.com,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/bsp-hotplug] x86, apic: Disable BSP if boot cpu is AP
References: <20130829092804.5476.95588.stgit@localhost6.localdomain6> <tip-1d79e607332d67d9132c176d99b5e7fabe1b6b7f@git.kernel.org>
In-Reply-To: <tip-1d79e607332d67d9132c176d99b5e7fabe1b6b7f@git.kernel.org>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/09/2013 04:16 PM, tip-bot for HATAYAMA Daisuke wrote:
> Commit-ID:  1d79e607332d67d9132c176d99b5e7fabe1b6b7f
> Gitweb:     http://git.kernel.org/tip/1d79e607332d67d9132c176d99b5e7fabe1b6b7f
> Author:     HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
> AuthorDate: Thu, 29 Aug 2013 18:28:04 +0900
> Committer:  H. Peter Anvin <hpa@linux.intel.com>
> CommitDate: Wed, 9 Oct 2013 15:41:11 -0700
> 
> x86, apic: Disable BSP if boot cpu is AP

This patch seems to trigger build failures in some configurations.
Specifically:

(.init.text+0x1307): undefined reference to `boot_cpu_is_bsp_init'

Unfortunately I don't have the specific configuration which triggers the
failure, as this was discovered by Fengguang's robot.

	-hpa

