Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755722AbaE3Shz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 14:37:55 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:33192 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754589AbaE3Shy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 14:37:54 -0400
Date: Fri, 30 May 2014 21:37:42 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Thomas Wood <tommyandrena@gmail.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging/goldfish: Clean up trailing whitespace.
Message-ID: <20140530183742.GJ15585@mwanda>
References: <1401474005-27804-1-git-send-email-tommyandrena@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1401474005-27804-1-git-send-email-tommyandrena@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 30, 2014 at 11:20:05AM -0700, Thomas Wood wrote:
> When using scripts/checkpatch.pl, there are errors about trailing whitespace. Use scripts/cleanfile to remove these errors.
> 

Someone already fixed these.  Work against linux-next.

regards,
dan carpenter

