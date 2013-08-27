Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753731Ab3H0S5x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 14:57:53 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:45835 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752361Ab3H0S5v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 14:57:51 -0400
Date: Tue, 27 Aug 2013 21:57:36 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Rupesh Gujare <rupesh.gujare@atmel.com>
Cc: devel@linuxdriverproject.org, gregkh@linuxfoundation.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] staging: ozwpan: Increase ISOC IN buffer depth
Message-ID: <20130827185736.GL6329@mwanda>
References: <1377618823-12246-1-git-send-email-rupesh.gujare@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1377618823-12246-1-git-send-email-rupesh.gujare@atmel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 27, 2013 at 04:53:40PM +0100, Rupesh Gujare wrote:
> Increase ISOC IN buffer depth to 100 units.
> 

This change log is not useful.  What are the user visible effects of
this bug?

regards,
dan carpenter

