Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751306Ab3CARGi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 12:06:38 -0500
Received: from mx1.redhat.com ([209.132.183.28]:46030 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751059Ab3CARGh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 12:06:37 -0500
Date: Fri, 1 Mar 2013 17:06:34 +0000
From: "Richard W.M. Jones" <rjones@redhat.com>
To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: Expose loops_per_jiffy through /proc/cpuinfo.
Message-ID: <20130301170634.GB25008@rhmail.home.annexia.org>
References: <1362155923-884-1-git-send-email-rjones@redhat.com>
 <20130301164643.GA25008@rhmail.home.annexia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130301164643.GA25008@rhmail.home.annexia.org>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 01, 2013 at 04:46:43PM +0000, Richard W.M. Jones wrote:
> Ignore this patch, it's obviously wrong.  Too late in the afternoon ...

Actually, NOT wrong.  You can't get HZ from userspace, so
exporting loops_per_jiffy like this is necessary.

Rich.

-- 
Richard Jones, Virtualization Group, Red Hat http://people.redhat.com/~rjones
libguestfs lets you edit virtual machines.  Supports shell scripting,
bindings from many languages.  http://libguestfs.org
