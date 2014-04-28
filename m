Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754544AbaD1JdP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 05:33:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2900 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753652AbaD1JdN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 05:33:13 -0400
Message-ID: <535E2054.8050805@redhat.com>
Date: Mon, 28 Apr 2014 11:33:08 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Jet Chen <jet.chen@intel.com>
CC: LKML <linux-kernel@vger.kernel.org>, lkp@01.org,
        Fengguang Wu <fengguang.wu@intel.com>
Subject: Re: [KVM] BUG: unable to handle kernel NULL pointer dereference at
 00000000000002b0
References: <534B930A.4070507@intel.com>
In-Reply-To: <534B930A.4070507@intel.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 14/04/2014 09:49, Jet Chen ha scritto:
> Hi Paolo,
>
> We noticed the below kernel BUG on
>
> git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master

What commit?

Paolo
