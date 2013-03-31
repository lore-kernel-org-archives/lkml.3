Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756206Ab3CaEa2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Mar 2013 00:30:28 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:45331 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751868Ab3CaEa1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Mar 2013 00:30:27 -0400
Message-ID: <1364704217.9519.0.camel@ubuntu>
Subject: Re: [PATCH] checkpatch: do not exit in main process subroutine
From: Joe Perches <joe@perches.com>
To: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
Cc: Andy Whitcroft <apw@canonical.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Sun, 31 Mar 2013 04:30:17 +0000
In-Reply-To: <5156BECE.9070701@huawei.com>
References: <5153BC45.807@huawei.com> <5156BECE.9070701@huawei.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.0-0ubuntu3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-03-30 at 18:30 +0800, zhangwei(Jovi) wrote:
> On 2013/3/28 11:43, zhangwei(Jovi) wrote:
> > Currently checkpatch program exit when process empty file,
> > This will cause issue when @ARGV include many files ready to check.
> > 
> > For example, there may have Module.symvers empty file in kernel directory.
> > 
> > [root@jovi ~]# scripts/checkpatch.pl -f kernel/*
> > 
> > then many file "after" empty file will not be check by script.
> > so disallow exit in main process subroutine.
> > 
> > Signed-off-by: zhangwei(Jovi) <jovi.zhangwei@huawei.com>
> Joe, Ping?

Off on a holiday.  Will check later.

