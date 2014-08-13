Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753747AbaHMR2m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 13:28:42 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:36644 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752073AbaHMR2l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 13:28:41 -0400
Date: Wed, 13 Aug 2014 20:28:45 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Seunghun Lee <waydi1@gmail.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        Brian Swetland <swetland@google.com>, linux-kernel@vger.kernel.org,
        gerb.stralko@gmail.com
Subject: Re: [PATCH] staging: android: fix a possible memory leak
Message-ID: <20140813172845.GW4856@mwanda>
References: <1407949368-2791-1-git-send-email-waydi1@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1407949368-2791-1-git-send-email-waydi1@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 14, 2014 at 02:02:48AM +0900, Seunghun Lee wrote:
> Memory allocated by kstrdup should be freed.
> 
> CC: Brian Swetland <swetland@google.com>
> Signed-off-by: Seunghun Lee <waydi1@gmail.com>

Looks good.

regards,
dan carpenter

