Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752182AbaAFBfQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jan 2014 20:35:16 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:53555 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751460AbaAFBfO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jan 2014 20:35:14 -0500
Date: Sun, 05 Jan 2014 20:35:12 -0500 (EST)
Message-Id: <20140105.203512.1357051953391472623.davem@davemloft.net>
To: wei.liu2@citrix.com
Cc: jwboyer@redhat.com, Paul.Durrant@citrix.com, netdev@vger.kernel.org,
        ian.campbell@citrix.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xen-netback: Include header for vmalloc
From: David Miller <davem@davemloft.net>
In-Reply-To: <20140105222221.GA16984@zion.uk.xensource.com>
References: <20140105152401.GF18517@hansolo.jdub.homelinux.org>
	<20140105222221.GA16984@zion.uk.xensource.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Sun, 05 Jan 2014 17:35:14 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Liu <wei.liu2@citrix.com>
Date: Sun, 5 Jan 2014 22:22:21 +0000

> On Sun, Jan 05, 2014 at 10:24:01AM -0500, Josh Boyer wrote:
>> Commit ac3d5ac27735 ("xen-netback: fix guest-receive-side array sizes")
>> added calls to vmalloc and vfree in the interface.c file without including
>> <linux/vmalloc.h>.  This causes build failures if the
>> -Werror=implicit-function-declaration flag is passed.
>> 
>> Signed-off-by: Josh Boyer <jwboyer@fedoraproject.org>
> 
> Acked-by: Wei Liu <wei.liu2@citrix.com>

Applied, thanks everyone.
