Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966988AbaFTKup (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 06:50:45 -0400
Received: from mailapp01.imgtec.com ([195.59.15.196]:5672 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966632AbaFTKun (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 06:50:43 -0400
Message-ID: <53A411FF.5070505@imgtec.com>
Date: Fri, 20 Jun 2014 11:50:39 +0100
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Sorin Dumitru <sdumitru@ixiacom.com>, <linux-kernel@vger.kernel.org>,
        <linux-mips@linux-mips.org>
CC: <ralf@linux-mips.org>
Subject: Re: [PATCH] mips: n32: use compat getsockopt syscall
References: <1403250786-9763-1-git-send-email-sdumitru@ixiacom.com> <53A404D2.3030303@imgtec.com> <53A40FB0.2020503@ixiacom.com>
In-Reply-To: <53A40FB0.2020503@ixiacom.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.154.101]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20/06/14 11:40, Sorin Dumitru wrote:
> On 06/20/14 12:54, James Hogan wrote:
>> On 20/06/14 08:53, Sorin Dumitru wrote:
>>> Signed-off-by: Sorin Dumitru <sdumitru@ixiacom.com>
>>
>> A little more commit message wouldn't hurt. Did it break a particular
>> program?
> 
> Yes, it was found by an internal program trying to get IP_PKTOPTIONS on
> a cavium octeon board.
> 
> Should I resubmit stating what was broken in the commit message?

Yeh, if you don't mind. I think it's useful to know exactly why a change
was made and what it fixes when later digging through the git history
(e.g. commit 515c7af85ed9 is a great example of that).

Thanks
James
