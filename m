Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753184Ab3EQEqy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 00:46:54 -0400
Received: from mail-vb0-f41.google.com ([209.85.212.41]:35089 "EHLO
	mail-vb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750972Ab3EQEqx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 00:46:53 -0400
MIME-Version: 1.0
In-Reply-To: <51952C3B.80202@cogentembedded.com>
References: <1368689438-23889-1-git-send-email-prabhakar.csengg@gmail.com>
 <1368689438-23889-6-git-send-email-prabhakar.csengg@gmail.com> <51952C3B.80202@cogentembedded.com>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Fri, 17 May 2013 10:16:32 +0530
Message-ID: <CA+V-a8sWbUa-uPnto6D3Ncafb_PRb1yTiuF1kFmroU8RVkvh2Q@mail.gmail.com>
Subject: Re: [PATCH 5/5] net: davinci_mdio: trivial cleanup
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

On Fri, May 17, 2013 at 12:28 AM, Sergei Shtylyov
<sergei.shtylyov@cogentembedded.com> wrote:
> On 16-05-2013 11:30, Lad Prabhakar wrote:
>
>> From: Lad, Prabhakar <prabhakar.csengg@gmail.com>
>
>
>> remove unwanted header inclusion and sort the alphabetically
>
>
>    s/the/them/.
OK
>
>
>> also guard the davinci_mdio_of_mtable table and davinci_mdio_probe_dt()
>> with CONFIG_OF.
>
>
>    Saying "also" in the changelog is often a good sign there should be one
> more patch -- as in this case.
>
OK I'll split the patch.

Regards,
--Prabhakar Lad
