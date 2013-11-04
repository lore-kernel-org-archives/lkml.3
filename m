Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752822Ab3KDM6x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 07:58:53 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:33181 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751632Ab3KDM6w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 07:58:52 -0500
Date: Mon, 4 Nov 2013 15:58:27 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Ondrej Zary <linux@rainbow-software.org>
Cc: Aldo Iljazi <mail@aldo.io>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org
Subject: Re: [PATCH] Staging: ft1000: fixed a few styling issues
Message-ID: <20131104125827.GO26669@mwanda>
References: <1383567322-22879-1-git-send-email-mail@aldo.io>
 <201311041332.21209.linux@rainbow-software.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201311041332.21209.linux@rainbow-software.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 04, 2013 at 01:32:20PM +0100, Ondrej Zary wrote:
> 
> Shouldn't this be removed from the code, converted to a binary file and loaded 
> by the kernel firmware loader instead?

I have no idea.  We may as well apply this and do that later unless
someone wants to jump on it before 3.13-rc1 is released.

regards,
dan carpenter

