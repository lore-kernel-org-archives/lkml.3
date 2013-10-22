Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755014Ab3JVX41 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 19:56:27 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:57332 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753439Ab3JVX40 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 19:56:26 -0400
Message-ID: <526710A4.9010705@linaro.org>
Date: Tue, 22 Oct 2013 19:56:20 -0400
From: David Long <dave.long@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Oleg Nesterov <onestero@redhat.com>
CC: Oleg Nesterov <oleg@redhat.com>, linux-arm-kernel@lists.infradead.org,
        Rabin Vincent <rabin@rab.in>, "Jon Medhurst (Tixy)" <tixy@linaro.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 02/13] uprobes: allow ignoring of probe hits
References: <1381871068-27660-1-git-send-email-dave.long@linaro.org> <1381871068-27660-3-git-send-email-dave.long@linaro.org> <20131019170214.GA8324@redhat.com> <5265F4EB.2060803@linaro.org> <1641249240.11471136.1382441151287.JavaMail.root@redhat.com>
In-Reply-To: <1641249240.11471136.1382441151287.JavaMail.root@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/22/13 07:25, Oleg Nesterov wrote:
> Sorry for top-posting/formatting,
>
> Do you mean arch_uprobe_skip_sstep() ?
>
> Yes, this __weak is wrong, already fixed in my tree. See
> http://marc.info/?l=linux-mips&m=138132052022388&w=2
>

That was one I was looking at, but it seemed to me a general opportunity 
for runtime failures in the kernel that could have been detected at link 
time.  But that's a topic for discussion elsewhere I should think.

-dl

