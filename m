Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755810Ab3EQUTu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 16:19:50 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:35430 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754991Ab3EQUTt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 16:19:49 -0400
Message-ID: <1368821982.24376.3.camel@concerto>
Subject: Re: [PATCH 3/3] BusLogic: Use more conventional argument order for
 logging
From: Khalid Aziz <khalid.aziz@oracle.com>
To: Joe Perches <joe@perches.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Fri, 17 May 2013 14:19:42 -0600
In-Reply-To: <5fdcd2200869713c58b52d550281da9aa9195efb.1368765873.git.joe@perches.com>
References: <cover.1368754556.git.khalid.aziz@oracle.com>
	 <5fdcd2200869713c58b52d550281da9aa9195efb.1368765873.git.joe@perches.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-05-16 at 21:58 -0700, Joe Perches wrote:
> Subsystem specific logging messages generally use
> 	subsystem_<level>(struct subsystem *, fmt, ...)
> not
> 	subsystem_<level>(fmt, struct subsystem *, ...)
> 
> Convert to use the more generally used kernel style.
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  drivers/scsi/BusLogic.c | 304 ++++++++++++++++++++++++------------------------
>  drivers/scsi/BusLogic.h |  24 ++--
>  2 files changed, 161 insertions(+), 167 deletions(-)

Reviewed-by: Khalid Aziz <khalid.aziz@oracle.com>


