Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753897Ab3CABpO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 20:45:14 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:37972 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751667Ab3CABpM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 20:45:12 -0500
Message-ID: <1362102307.9158.32.camel@falcor1>
Subject: Re: IMA: How to manage user space signing policy with others
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux kernel mailing list <linux-kernel@vger.kernel.org>,
        linux-security-module@vger.kernel.org
Date: Thu, 28 Feb 2013 20:45:07 -0500
In-Reply-To: <20130228200847.GD11360@redhat.com>
References: <20130228151333.GB11360@redhat.com>
	 <1362079419.2908.390.camel@falcor1.watson.ibm.com>
	 <20130228200847.GD11360@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13030101-9360-0000-0000-000011205B98
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-02-28 at 15:08 -0500, Vivek Goyal wrote:

> - New hook is required so that we can call it after locking down the
>   executable in memory. Even if we have a separate method/hook for
>   bzImage verification, it does not take away the need for verifying
>   /sbin/kexec excutable signature. Because apart from bzImage, that
>   process loads lot more information like purgatory, bootparams and
>   there is no way to verify signatures of those. So by verifying
>   /sbin/kexec it is assumed that purgaotry and bootparams can be
>   trusted because it is coming from a signed process.

Ok, this is what I was missing.

thanks,

Mimi

