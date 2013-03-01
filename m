Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751619Ab3CASRh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 13:17:37 -0500
Received: from mga09.intel.com ([134.134.136.24]:6281 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751223Ab3CASRg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 13:17:36 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,762,1355126400"; 
   d="scan'208";a="292421275"
Message-ID: <5130F0B7.3090804@linux.intel.com>
Date: Fri, 01 Mar 2013 10:17:27 -0800
From: "H. Peter Anvin" <hpa@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130219 Thunderbird/17.0.3
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: mingo@kernel.org, hpa@zytor.com, lans.zhang2008@gmail.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/cleanups] x86_64: Use __BOOT_DS instead_of __KERNEL_DS
 for safety
References: <51300267.6000008@gmail.com> <tip-b317219b322e36e25150d7b64f4532401779959d@git.kernel.org> <CAE9FiQWmwj2urS-jY-+Bifdzx1z3om839qOowz0QZHtxLQoVzA@mail.gmail.com>
In-Reply-To: <CAE9FiQWmwj2urS-jY-+Bifdzx1z3om839qOowz0QZHtxLQoVzA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/01/2013 09:47 AM, Yinghai Lu wrote:
> On Thu, Feb 28, 2013 at 9:23 PM, tip-bot for gmail <tipbot@zytor.com> wrote:
>> Commit-ID:  b317219b322e36e25150d7b64f4532401779959d
>> Gitweb:     http://git.kernel.org/tip/b317219b322e36e25150d7b64f4532401779959d
>> Author:     gmail <lans.zhang2008@gmail.com>
> 
> name is messed up.
> 
> should be
> 
> Lans Zhang <lans.zhang2008@gmail.com>
> 

Indeed.  I'll adjust it.

Lans, please fix your mail setup for next time.

	-hpa


