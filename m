Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752098Ab3KJWAp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Nov 2013 17:00:45 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:42987 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752147Ab3KJWAk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Nov 2013 17:00:40 -0500
USER-AGENT: Mutt/1.5.21 (2010-09-15)
MIME-Version: 1.0
Message-ID: <20131110212835.GB5302@mwanda>
Date: Sun, 10 Nov 2013 13:28:35 -0800 (PST)
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Michal Nazarewicz <mpn@google.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        Ian Abbott <abbotti@mev.co.uk>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: comedi: fix potentially uninitialised variable
References: <1384108669-23392-1-git-send-email-mpn@google.com>
In-Reply-To: <1384108669-23392-1-git-send-email-mpn@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 10, 2013 at 07:37:49PM +0100, Michal Nazarewicz wrote:
> From: Michal Nazarewicz <mina86@mina86.com>
> 
> If none of the if conditions take a true path, the ret variable will
> never be assigned a value.

Don't use a From: unless you are sending it on behalf of another sender.

You need a Signed-off-by line and it has to match your email address
which you used to send the email.

Otherwise, the patch is good an fixes an important bug.

regards,
dan carpenter
