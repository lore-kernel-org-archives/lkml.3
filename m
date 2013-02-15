Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936080Ab3BOQaB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 11:30:01 -0500
Received: from mout.gmx.net ([212.227.15.18]:63837 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755870Ab3BOQ37 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 11:29:59 -0500
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX19IjYVZnThIbV2moQbk6Mp4GVUDRbpHBAA/BQx45H
	NZdM0gzRdo95OB
From: Peter =?iso-8859-1?q?H=FCwe?= <PeterHuewe@gmx.de>
To: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: Clang Analyzer was Re: [PATCH 3/7 v2] staging/ozwpan: Fix NULL vs zero in ozeltbuf.c (sparse warning)
Date: Fri, 15 Feb 2013 17:34:24 +0100
User-Agent: KMail/1.13.7 (Linux/3.7.7; KDE/4.9.3; x86_64; ; )
Cc: Rupesh Gujare <rupesh.gujare@atmel.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Kernel Janitors <kernel-janitors@vger.kernel.org>
References: <20130215084517.GB6802@mwanda> <201302151657.14726.PeterHuewe@gmx.de> <20130215161102.GK6853@mwanda>
In-Reply-To: <20130215161102.GK6853@mwanda>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201302151734.24623.PeterHuewe@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, 15. Februar 2013, 17:11:02 schrieb Dan Carpenter:
> Are you using this version of clang?:
> 
> http://git.linuxfoundation.org/llvmlinux.git/
> 
> regards,
> dan carpenter

Hi,

nope - plain vanilla llvm/clang, but I use some of the kernel patches from 
there:
http://git.linuxfoundation.org/?p=llvmlinux.git;a=tree;f=arch/x86_64/patches;hb=master

The main reason for not using llvmlinux is that it builds a lot more than I 
need (e.g. buildbot/qemu) but maybe I should give it a try some time.


Peter
