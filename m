Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755709Ab3EQUSq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 16:18:46 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:37538 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755404Ab3EQUSp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 16:18:45 -0400
Message-ID: <1368821917.24376.1.camel@concerto>
Subject: Re: [PATCH 1/3] BusLogic: Add __printf verification, fix fallout
From: Khalid Aziz <khalid.aziz@oracle.com>
To: Joe Perches <joe@perches.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Fri, 17 May 2013 14:18:37 -0600
In-Reply-To: <0424edbf1b8d1c432565ff5315d5c694a416fe0e.1368765873.git.joe@perches.com>
References: <cover.1368754556.git.khalid.aziz@oracle.com>
	 <0424edbf1b8d1c432565ff5315d5c694a416fe0e.1368765873.git.joe@perches.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-05-16 at 21:58 -0700, Joe Perches wrote:
> Make format and arguments match.
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  drivers/scsi/BusLogic.c | 50 ++++++++++++++++++++++++-------------------------
>  drivers/scsi/BusLogic.h |  1 +
>  2 files changed, 26 insertions(+), 25 deletions(-)

Reviewed-by: Khalid Aziz <khalid.aziz@oracle.com>


