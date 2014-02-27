Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753343AbaB0NmF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 08:42:05 -0500
Received: from mail-yh0-f51.google.com ([209.85.213.51]:47429 "EHLO
	mail-yh0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751759AbaB0NmA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 08:42:00 -0500
Message-ID: <530F40A5.5060202@gmail.com>
Date: Thu, 27 Feb 2014 10:41:57 -0300
From: Juan Manuel Cabo <juanmanuel.cabo@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Kieran Clancy <clancy.kieran@gmail.com>,
        Li Guang <lig.fnst@cn.fujitsu.com>
CC: Len Brown <lenb@kernel.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lan Tianyu <tianyu.lan@intel.com>,
        Dennis Jansen <dennis.jansen@web.de>
Subject: Hello Kieran
References: <1393429360-4344-1-git-send-email-clancy.kieran@gmail.com> <530E9BEF.8080601@cn.fujitsu.com> <CAGf84Q+Xd9EUjOEMe3+EMRhdPaFgnAjNDOoPZmf=gn8mi=FhWw@mail.gmail.com>
In-Reply-To: <CAGf84Q+Xd9EUjOEMe3+EMRhdPaFgnAjNDOoPZmf=gn8mi=FhWw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Kieran!!

Dennis has an AMD laptop, NP535U3C-A04DE, and found it to be 9
(which I guess was an off by one in his modification
of the userspace workaround and was really 8):
        https://bugzilla.kernel.org/show_bug.cgi?id=44161#c146

I found it to be 8 for me, both in the patch and in my new userspace workaround
(which doesn't ask for the same event twice now that it pauses for 1ms,
as the kernel does too):
      https://bugzilla.kernel.org/show_bug.cgi?id=44161#c162

ANd I think I saw someone else with 8 too but don't remember where.

BUT, there might be more laptops existing or future, samsung or other,
that might queue more than 8. Li Guang (lig.fnst@cn.fujitsu.com)
said that he saw EC firmware's with 32, and that true maximum is 255.


So in my opinion it's best to put max. iters. at 255.

Cheers!
--jm

