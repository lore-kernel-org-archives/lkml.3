Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752850Ab3IVSXU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Sep 2013 14:23:20 -0400
Received: from mail-vb0-f45.google.com ([209.85.212.45]:38802 "EHLO
	mail-vb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752359Ab3IVSXT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Sep 2013 14:23:19 -0400
MIME-Version: 1.0
In-Reply-To: <l1n80j$ofi$1@ger.gmane.org>
References: <l1n80j$ofi$1@ger.gmane.org>
Date: Sun, 22 Sep 2013 20:23:18 +0200
Message-ID: <CAFLxGvweL_O16TwvERsMSwf1UPa5BFwSyFNNRu6Z1CD4ExZXSg@mail.gmail.com>
Subject: Re: Would an "information module" be useful?
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: Markus Elfring <Markus.Elfring@web.de>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 22, 2013 at 7:05 PM, Markus Elfring <Markus.Elfring@web.de> wrote:
> Hello,
>
> I became interested in an use case where I want to pass customised data from the
> boot command-line to other user processes. I have read the available
> documentation in the way that kernel modules provide such a means to get
> additional parameters recorded.
>
> I have got the understanding that a kernel module provides also a name space for
> such boot parameters. (Are they also called "attributes" there?)
> Now I would be interested to create a module for my needs so that the passed
> data will be stored in the sys file system. Which software component is
> responsible for this task?
>
> I find that another implementation detail needs more clarification. The modules
> usually drive some hardware.
> https://www.kernel.org/doc/Documentation/filesystems/sysfs.txt
>
> But I am looking for a kind of kernel module which does not serve any hardware.
> I imagine that it should be sufficient to register it as a simple information sink.
>
> How do you think about my considerations?
> Would you like to share any alternative ideas?

Why can't you use /proc/cmdline?
systemd for example parses /proc/cmdline by looking at keys like "systemd.*=".
(see parse_proc_cmdline())

-- 
Thanks,
//richard
