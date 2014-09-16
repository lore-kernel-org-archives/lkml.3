Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753972AbaIPXTG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 19:19:06 -0400
Received: from mail-vc0-f180.google.com ([209.85.220.180]:52639 "EHLO
	mail-vc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753144AbaIPXTE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 19:19:04 -0400
MIME-Version: 1.0
X-Originating-IP: [2001:470:8:ee7:ad06:4a24:71d3:da04]
In-Reply-To: <20140917090020.1f3c2c30@canb.auug.org.au>
References: <20140916171102.61509be5@canb.auug.org.au> <CAOFdcFMDnR50cS-Geb0S1S2VRPzZqDr9zzqUp-DpMYLfF0qtvQ@mail.gmail.com>
 <20140917090020.1f3c2c30@canb.auug.org.au>
From: Peter Foley <pefoley2@pefoley.com>
Date: Tue, 16 Sep 2014 19:18:42 -0400
Message-ID: <CAOFdcFOXQRmxFQV_ei3xcdRLaCxEa4yjc=s=xjNM6R3SQBySgg@mail.gmail.com>
Subject: Re: linux-next: build failure after merge of the rd-docs tree
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Randy Dunlap <rdunlap@infradead.org>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 16, 2014 at 7:00 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi Peter,
>
> My build machine runs Debian stable which only has libc6 version 2.13.

Ok, depending on a specific glibc version seems kinda hacky.
Maybe we should just disable auto-building vdso_test?

Randy?
