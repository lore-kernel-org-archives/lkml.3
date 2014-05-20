Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752707AbaETMwQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 08:52:16 -0400
Received: from mx01-fr.bfs.de ([193.174.231.67]:38854 "EHLO mx01-fr.bfs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751266AbaETMwP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 08:52:15 -0400
Message-ID: <537B4FF2.4010502@bfs.de>
Date: Tue, 20 May 2014 14:52:02 +0200
From: walter harms <wharms@bfs.de>
Reply-To: wharms@bfs.de
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; de; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: Peter Senna Tschudin <peter.senna@gmail.com>, devel@driverdev.osuosl.org,
        Florian Schilhabel <florian.c.schilhabel@googlemail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH 1/8] staging: r8712u: Remove useless return variables
References: <1400582028-24990-1-git-send-email-peter.senna@gmail.com> <537B38FF.4050106@bfs.de> <20140520114113.GG15585@mwanda>
In-Reply-To: <20140520114113.GG15585@mwanda>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Am 20.05.2014 13:41, schrieb Dan Carpenter:
> Those concerns are valid but the code was like that in the original so
> we should merge this patch as is and hope some volunteer will fix things
> up in a follow on patch.
> 
> Fixing them in this patch would be a mistake anyway because of the one
> thing per patch rule.
> 

I see this as a bordercase, the patch from Peter is correct in the context of
removing useless return variables. I question the whole function in the hope
that the maintainer will decide that the function can go completely.

re,
 wh
