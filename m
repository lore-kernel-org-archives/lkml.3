Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753817Ab3EQExi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 00:53:38 -0400
Received: from mail-vb0-f49.google.com ([209.85.212.49]:57593 "EHLO
	mail-vb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751217Ab3EQExh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 00:53:37 -0400
MIME-Version: 1.0
In-Reply-To: <51952BA2.9040900@cogentembedded.com>
References: <1368689438-23889-1-git-send-email-prabhakar.csengg@gmail.com>
 <1368689438-23889-3-git-send-email-prabhakar.csengg@gmail.com> <51952BA2.9040900@cogentembedded.com>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Fri, 17 May 2013 10:23:16 +0530
Message-ID: <CA+V-a8vWLWXL7WP3dzKXM0yFAkoU4UxfaqJ4E1t0gQhRp8zj-w@mail.gmail.com>
Subject: Re: [PATCH 2/5] net: davinci_emac: remove unwanted header inclusion
 and sort the alphabetically
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc: DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jiri Kosina <trivial@kernel.org>, netdev@vger.kernel.org,
        Mugunthan V N <mugunthanvnm@ti.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sergei,

Thanks for the review.

On Fri, May 17, 2013 at 12:25 AM, Sergei Shtylyov
<sergei.shtylyov@cogentembedded.com> wrote:
> On 16-05-2013 11:30, Lad Prabhakar wrote:
>
>> From: Lad, Prabhakar <prabhakar.csengg@gmail.com>
>
>
>> This patch removes unwanted header inclusion
>
>
>    Why are they unwanted?
>
The driver builds without this includes.

This is arguable, if I would have added a new driver with the only
#includes which were required to build thats accepted. But when I remove
unnecessary #includes from the existing drivers that's not acceptable ?

This applies to rest of the similar patches in the series.

>> and sorts them alphabetically
>
>
>    In the subject you typed "the" instead of "them".
>
Hmm carry forwarded this copy paste error every where will fix it in V2.

Regards,
--Prabhakar Lad
