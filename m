Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754332AbaFPH6A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 03:58:00 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:21523 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754254AbaFPH5y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 03:57:54 -0400
Date: Mon, 16 Jun 2014 10:57:42 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Martin Kepplinger <martink@posteo.de>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        forest@alittletooquiet.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: vt6655: remove unnecessary typedef struct.
Message-ID: <20140616075742.GA5500@mwanda>
References: <1402655023-23190-1-git-send-email-martink@posteo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1402655023-23190-1-git-send-email-martink@posteo.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 13, 2014 at 12:23:43PM +0200, Martin Kepplinger wrote:
> Remove a totally unnecessary typedef. This is more readable now.

Choose a lower case name for the struct, otherwise we have to change all
these again in a while.

regards,
dan carpenter

