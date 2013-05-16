Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752277Ab3EPS6G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 14:58:06 -0400
Received: from mail-lb0-f175.google.com ([209.85.217.175]:61515 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750835Ab3EPS6D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 14:58:03 -0400
Message-ID: <51952C3B.80202@cogentembedded.com>
Date: Thu, 16 May 2013 22:58:03 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Lad Prabhakar <prabhakar.csengg@gmail.com>
CC: DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jiri Kosina <trivial@kernel.org>, netdev@vger.kernel.org,
        Mugunthan V N <mugunthanvnm@ti.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/5] net: davinci_mdio: trivial cleanup
References: <1368689438-23889-1-git-send-email-prabhakar.csengg@gmail.com> <1368689438-23889-6-git-send-email-prabhakar.csengg@gmail.com>
In-Reply-To: <1368689438-23889-6-git-send-email-prabhakar.csengg@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16-05-2013 11:30, Lad Prabhakar wrote:

> From: Lad, Prabhakar <prabhakar.csengg@gmail.com>

> remove unwanted header inclusion and sort the alphabetically

    s/the/them/.

> also guard the davinci_mdio_of_mtable table and davinci_mdio_probe_dt()
> with CONFIG_OF.

    Saying "also" in the changelog is often a good sign there should be 
one more patch -- as in this case.

> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>

WBR, Sergei

