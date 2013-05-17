Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755855Ab3EQUTN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 16:19:13 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:37748 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755387Ab3EQUTL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 16:19:11 -0400
Message-ID: <1368821946.24376.2.camel@concerto>
Subject: Re: [PATCH 2/3] BusLogic: Coalesce formats with multiple string
 fragments
From: Khalid Aziz <khalid.aziz@oracle.com>
To: Joe Perches <joe@perches.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Fri, 17 May 2013 14:19:06 -0600
In-Reply-To: <1fe580d1ae95bff774f2561837a22ea772733863.1368765873.git.joe@perches.com>
References: <cover.1368754556.git.khalid.aziz@oracle.com>
	 <1fe580d1ae95bff774f2561837a22ea772733863.1368765873.git.joe@perches.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-05-16 at 21:58 -0700, Joe Perches wrote:
> Strings fragments coalesced by the compiler are
> difficult to grep.  Coalesce them instead.
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  drivers/scsi/BusLogic.c | 66 ++++++++++++++++++++++++-------------------------
>  1 file changed, 33 insertions(+), 33 deletions(-)

Reviewed-by: Khalid Aziz <khalid.aziz@oracle.com>


