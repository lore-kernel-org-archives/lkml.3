Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758915Ab3APJZ4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 04:25:56 -0500
Received: from mail-la0-f45.google.com ([209.85.215.45]:59527 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758688Ab3APJZx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 04:25:53 -0500
Message-ID: <50F6721A.3080108@gmail.com>
Date: Wed, 16 Jan 2013 10:25:46 +0100
From: =?ISO-8859-1?Q?David_Nystr=F6m?= <david.c.nystrom@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: Linux 3.8-rc1
References: <CA+55aFyd0Wk=hPqiRmk5MMnrwPhse5k1Aih9P-j-Badr7kwhbw@mail.gmail.com> <20121222025722.GA27621@home.goodmis.org>
In-Reply-To: <20121222025722.GA27621@home.goodmis.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/22/2012 03:57 AM, Steven Rostedt wrote:
> On Fri, Dec 21, 2012 at 06:00:58PM -0800, Linus Torvalds wrote:
>> The longest night of the year is upon us (*), and what better thing to
>> do than get yourself some nice mulled wine, sit back, relax, and play
>
> Hi Linus,
>
> Was there anything wrong with Frederic's printk patches? They are needed
> as one of the steps to acheive tickless for a CPU running a single task.
>
>   https://lkml.org/lkml/2012/12/17/177
>
> Maybe his "RFC" threw you for a loop. It was RFC as, if you're OK with
> it, please pull it, otherwise please comment to what you think is
> wrong with it.
>
> It's been in linux-next for a while without anyone complaining about it.
> I replied to his patch with the diff against your tree as Frederic left
> that out.
>
> Thanks,
>
> -- Steve
>

+1 on this.

/David

