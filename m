Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932152AbaGaDRM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 23:17:12 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:41817 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932104AbaGaDRK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 23:17:10 -0400
Message-ID: <53D9B52A.2070604@gmail.com>
Date: Thu, 31 Jul 2014 08:46:58 +0530
From: Anil Shashikumar Belur <askb23@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: tklauser@distanz.ch, dan.carpenter@oracle.com, bjorn@mork.no,
        silvio.fricke@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] staging: vt6655: ioctl.c - missing __user annotation
References: <1406725197-18530-1-git-send-email-askb23@gmail.com> <20140731000854.GA8934@kroah.com>
In-Reply-To: <20140731000854.GA8934@kroah.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thursday 31 July 2014 05:38 AM, Greg KH wrote:
>
> This patch doesn't apply against my tree at all, what did you make it
> against?
>
> Always work against linux-next, or the staging-next branch of my
> staging.git tree on git.kernel.org.
>
> thanks,
>
> greg k-h
Hi,

I am working on staging.git. After rebasing with staging-next, git log
shows someone has recently submitted this fix.

Thanks,
Anil


