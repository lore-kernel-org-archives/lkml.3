Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754406Ab3HESVo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 14:21:44 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:51777 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753796Ab3HESVn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 14:21:43 -0400
Date: Mon, 5 Aug 2013 21:21:28 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Rupesh Gujare <rupesh.gujare@atmel.com>
Cc: devel@linuxdriverproject.org, gregkh@linuxfoundation.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] staging: ozwpan: Reset port configuration number.
Message-ID: <20130805182128.GL5051@mwanda>
References: <1375724415-10801-1-git-send-email-rupesh.gujare@atmel.com>
 <1375724415-10801-4-git-send-email-rupesh.gujare@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375724415-10801-4-git-send-email-rupesh.gujare@atmel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 05, 2013 at 06:40:14PM +0100, Rupesh Gujare wrote:
> Make sure that we reset port configuration no. when PD departs.
> 

What happens if we don't do this?  What is the user visible effect
of this patch?

regards,
dan carpenter

