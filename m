Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751234AbaGaMob (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 08:44:31 -0400
Received: from admin.compro.net ([12.186.155.30]:62193 "HELO mx2.compro.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750768AbaGaMoa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 08:44:30 -0400
X-BYPSHEADER: 905412
X-SMScore: -200
Message-ID: <53DA3A2D.90403@compro.net>
Date: Thu, 31 Jul 2014 08:44:29 -0400
From: Mark Hounschell <markh@compro.net>
Reply-To: markh@compro.net
Organization: Compro Computer Svcs.
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Daeseok Youn <daeseok.youn@gmail.com>, lidza.louina@gmail.com
CC: gregkh@linuxfoundation.org, driverdev-devel@linuxdriverproject.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        dan.carpenter@oracle.com
Subject: Re: [PATCH V2] staging: dgap: introduce dgap_cleanup_nodes()
References: <166070137.57941.1406779444750.JavaMail.root@mx2.compro.net>
In-Reply-To: <166070137.57941.1406779444750.JavaMail.root@mx2.compro.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/31/2014 12:02 AM, Daeseok Youn wrote:
> When a configration file is parsed with dgap_parsefile(),
> makes nodes for saving configrations for board.
>
> Making a node will allocate node memory and strings for saving
> configrations with kstrdup().
>
> So these are freed when dgap is unloaded or failed to initialize.
>
> Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
> ---
> V2: Do not need to free for NULLNODE.
>
> I have been too busy to solve this issue, sorry for late.
>
> Mark, Can you test this patch? I try to make simple module which is
> testing dgap_parsefile() and dgap_cleanup_nodes().
>

I'll be happy to, but I can't do it until Monday. I'm not where the 
hardware is until then.

Regards
Mark

