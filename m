Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753506AbaETMX1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 08:23:27 -0400
Received: from mail-la0-f42.google.com ([209.85.215.42]:34865 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753277AbaETMXY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 08:23:24 -0400
Message-ID: <537B493B.8020008@cogentembedded.com>
Date: Tue, 20 May 2014 16:23:23 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
CC: Karsten Keil <isdn@linux-pingi.de>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] isdn: hisax: l3dss1.c: Fix for possible null pointer
 dereference
References: <1400534662-5729-1-git-send-email-rickard_strandqvist@spectrumdigital.se>	<537A771C.2050808@cogentembedded.com> <CAFo99gb3fOq=kXwiG=LsvRXHdgazQWv3t6XZqDOtRHc+FLxCbw@mail.gmail.com>
In-Reply-To: <CAFo99gb3fOq=kXwiG=LsvRXHdgazQWv3t6XZqDOtRHc+FLxCbw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 20-05-2014 1:56, Rickard Strandqvist wrote:

> Hi  Sergei

> I did not put the assignment in the if statement.

    You didn't but you changed the line it's on (which wasn't required BTW).

> Is it meant for me
> to change all the code around the parts I fix?

    No, the patch just needs to be checkpatch.pl-clean.

> There are many assignments in if in the l3dss1_cmd_global() funktion.

    You can leave them alone for now. You can also leave alone the line I was 
referring to.

> It's late and I'm tired, but I still can not see which of these pairs
> of features that I can remove ...?

>              if (ic->parm.dss1_io.timeout > 0) {
>                  if (!(pc = dss1_new_l3_process(st, -1))) {
>                      free_invoke_id(st, id);
>                      return (-2);
>                  }
>                  pc->prot.dss1.ll_id = ic->parm.dss1_io.ll_id; /* remember id */
>                  pc->prot.dss1.proc = ic->parm.dss1_io.proc; /* and procedure */
>              }

    I didn't quite get the question, if you were asking me.

> Best regards
> Rickard Strandqvist

WBR, Sergei

