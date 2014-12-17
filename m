Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752030AbaLQMLo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 07:11:44 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:40642 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751087AbaLQMLm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 07:11:42 -0500
Date: Wed, 17 Dec 2014 15:11:19 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: samuel kihahu <skihahu@gmail.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        speakup@linux-speakup.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: speakup: replace simple_strtoul with kstrtoul
Message-ID: <20141217121119.GL4856@mwanda>
References: <1418817362-29088-1-git-send-email-skihahu@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1418817362-29088-1-git-send-email-skihahu@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 17, 2014 at 02:56:02PM +0300, samuel kihahu wrote:
> Replacing obsolete simple_strtoul with kstrtoul.
> 

Nope.  That's wrong.  Learn how the functions are different beyond just
the name.

regards,
dan carpenter

