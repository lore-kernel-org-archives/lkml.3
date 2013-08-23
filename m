Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754969Ab3HWJIf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 05:08:35 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:31644 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754204Ab3HWJId (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 05:08:33 -0400
Date: Fri, 23 Aug 2013 12:05:09 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Rupesh Gujare <rupesh.gujare@atmel.com>
Cc: devel@linuxdriverproject.org, gregkh@linuxfoundation.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] staging: ozwpan: Create deferred work to destroy PD
 object.
Message-ID: <20130823090509.GS22811@mwanda>
References: <1377189531-24950-1-git-send-email-rupesh.gujare@atmel.com>
 <1377189531-24950-4-git-send-email-rupesh.gujare@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1377189531-24950-4-git-send-email-rupesh.gujare@atmel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 22, 2013 at 05:38:51PM +0100, Rupesh Gujare wrote:
> +/*------------------------------------------------------------------------------
>   * Context: softirq-serialized
>   */

Don't resend the patch, but these comments are not in kernel style.
It's explained in Documentation/kernel-doc-nano-HOWTO.txt

The main thing is that could you just delete all the --------
lines?

regards,
dan carpenter
