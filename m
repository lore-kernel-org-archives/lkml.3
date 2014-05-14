Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752231AbaENTfy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 15:35:54 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:41829 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752139AbaENTfx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 15:35:53 -0400
Date: Wed, 14 May 2014 22:35:30 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Pawel Lebioda <pawel.lebioda89@gmail.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: usbip: Fix bad fuction definitions in usbip
Message-ID: <20140514193530.GC8897@mwanda>
References: <20140514192823.GA5491@ThinkPad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140514192823.GA5491@ThinkPad>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 14, 2014 at 09:28:27PM +0200, Pawel Lebioda wrote:
> Fix bad function definitions in all files from drivers/staging/usbip directory
> 
> Signed-off-by: Pawel Lebioda <pawel.lebioda89@gmail.com>

This is fine, but next time try to be more specific in the subject and
also in the changelog.  Put the sparse warning in the changelog.  Say
that you are adding "void".

Btw, the reason for the void is because if it's not void then the
compiler won't complain if you pass a parameter to it.

void frob()
{
	printf("foo\n");
}

int main(void)
{
	frob(1, 2, 3);

	return 0;
}

regards,
dan carpenter

