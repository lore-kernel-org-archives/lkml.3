Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751394AbaEOEVA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 00:21:00 -0400
Received: from mail-ee0-f52.google.com ([74.125.83.52]:57855 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750724AbaEOEU7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 00:20:59 -0400
Message-ID: <537440A7.2020707@colorfullife.com>
Date: Thu, 15 May 2014 06:20:55 +0200
From: Manfred Spraul <manfred@colorfullife.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Davidlohr Bueso <davidlohr@hp.com>
CC: akpm@linux-foundation.org, aswin@hp.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] ipc,msg: loosen check for full queue
References: <1400012857-11733-1-git-send-email-davidlohr@hp.com> <1400012857-11733-6-git-send-email-davidlohr@hp.com> <5373AF39.7030406@colorfullife.com> <1400097031.3865.25.camel@buesod1.americas.hpqcorp.net>
In-Reply-To: <1400097031.3865.25.camel@buesod1.americas.hpqcorp.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Davidlohr,

On 05/14/2014 09:50 PM, Davidlohr Bueso wrote:
> Do you have any preferences? I can cook up a patch if you think that
> this merits Linux having MSGTQL.
MSGTQL means a global counter - therefore zero scalability. That's why I 
didn't implement it when I noticed the issue with 0-byte messages.
> Worst case scenario, we should update the msgsnd(2) manpage and document
> this unique Linux behavior.
I would document the current behavior.

--
     Manfred

