Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933085Ab3BLLpq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 06:45:46 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:42591 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758941Ab3BLLpn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 06:45:43 -0500
Message-ID: <1360669506.3524.233.camel@falcor1.watson.ibm.com>
Subject: Re: [PATCH 1/2] ima: Do not try to fix hash if file system does not
 support security xattr
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 12 Feb 2013 06:45:06 -0500
In-Reply-To: <1360613493-11969-2-git-send-email-vgoyal@redhat.com>
References: <1360613493-11969-1-git-send-email-vgoyal@redhat.com>
	 <1360613493-11969-2-git-send-email-vgoyal@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13021211-7282-0000-0000-0000140F8B49
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-02-11 at 15:11 -0500, Vivek Goyal wrote:
> vfs_getxattr_alloc() returns -EOPNOTSUPP if filesystem does not have
> security label enabled. In that case there is no point in continuing
> further and try to fix hashes (if ima_appraise=fix was specified) as
> that will fail too. Return early

There's a minor discrepancy between the patch title and the patch
description - not supported vs. not enabled.  Perhaps the title could be
abbreviated as well to something like "ima: detect security xattrs not
enabled".

thanks,

Mimi


