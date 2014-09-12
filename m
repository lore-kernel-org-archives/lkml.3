Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752138AbaILSVe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 14:21:34 -0400
Received: from mail1.bemta7.messagelabs.com ([216.82.254.99]:18797 "EHLO
	mail1.bemta7.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751038AbaILSVb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 14:21:31 -0400
X-Env-Sender: Benjamin.Romer@unisys.com
X-Msg-Ref: server-6.tower-201.messagelabs.com!1410546089!16943237!3
X-Originating-IP: [192.61.61.104]
X-StarScan-Received: 
X-StarScan-Version: 6.11.3; banners=-,-,-
X-VirusChecked: Checked
Date: Fri, 12 Sep 2014 14:20:41 -0400
To: <sudipm.mukherjee@gmail.com>, <David.Kershner@unisys.com>,
        <Benjamin.Romer@unisys.com>
CC: <sudipm.mukherjee@gmail.com>, <SParMaintainer@unisys.com>,
        <linux-kernel@vger.kernel.org>, <gregkh@linuxfoundation.org>,
        <devel@driverdev.osuosl.org>
Subject: Re: [PATCH] staging: unisys: uislib: uislib.c: sparse warning of
 context imbalance
References: <1410524846-10732-1-git-send-email-sudipm.mukherjee@gmail.com>
In-Reply-To: <1410524846-10732-1-git-send-email-sudipm.mukherjee@gmail.com>
User-Agent: Heirloom mailx 12.5 6/20/10
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-ID: <E1XSVSb-0001dp-Ro@ustr-romerbm-3.na.uis.unisys.com>
From: Ben Romer <benjamin.romer@unisys.com>
X-OriginalArrivalTime: 12 Sep 2014 18:21:29.0134 (UTC) FILETIME=[5F10CCE0:01CFCEB6]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sudip Mukherjee <sudipm.mukherjee@gmail.com> wrote:

> fixed sparse warning : context imbalance in 'destroy_device'
>                         unexpected unlock
> this patch will generate warning from checkpatch for
> lines over 80 character , but since those are user-visible strings
> so it was not modified.
>
> Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>

I tested this patch and it looks good also. Thanks! :)

-- Ben

Tested-by: Benjamin Romer <benjamin.romer@unisys.com>
Acked-by: Benjamin Romer <benjamin.romer@unisys.com>
