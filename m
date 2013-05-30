Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967677Ab3E3Gwo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 02:52:44 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:18799 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967616Ab3E3Gwg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 02:52:36 -0400
Date: Thu, 30 May 2013 09:52:25 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [patch] minix: bug widening a binary "not" operation
Message-ID: <20130530065225.GL23987@mwanda>
References: <20130516075148.GA7494@elgon.mountain>
 <20130529152826.043e95791122bbd39fc9d005@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130529152826.043e95791122bbd39fc9d005@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 29, 2013 at 03:28:26PM -0700, Andrew Morton wrote:

> But we should fix it to set a good example, and to quieten
> whatever-tool-i-suspect-you-were-using(?).

Linus wrote some Sparse patches that check for this but they haven't
been merged yet.

regards,
dan carpenter
