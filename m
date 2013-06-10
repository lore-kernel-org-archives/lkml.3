Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752000Ab3FJHXf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 03:23:35 -0400
Received: from cpsmtpb-ews10.kpnxchange.com ([213.75.39.15]:50105 "EHLO
	cpsmtpb-ews10.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751647Ab3FJHXd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 03:23:33 -0400
Message-ID: <1370848934.29355.3.camel@x61.thuisdomein>
Subject: Re: [PATCH] fs/cepth compile error
From: Paul Bolle <pebolle@tiscali.nl>
To: =?UTF-8?Q?=E5=86=AF=E5=8A=9B?= <lifeng1519@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Date: Mon, 10 Jun 2013 09:22:14 +0200
In-Reply-To: <CAEK8JBBKfNaUVkk7nvHki4TDiLFExkoGR5QTxDujxgtk4QyvkQ@mail.gmail.com>
References: <CAEK8JBBKfNaUVkk7nvHki4TDiLFExkoGR5QTxDujxgtk4QyvkQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 10 Jun 2013 07:22:15.0013 (UTC) FILETIME=[3B5DA950:01CE65AB]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-06-10 at 15:09 +0800, 冯力 wrote:
> I try to compile kernel v3.9.2 v3.9.5, It outputs couldn't find fs/cepth/ioctl.o
> Go to the dir and couldn't find the ioctl.c,only a ioctl.h file.But
> the ioctl.h isn't included by other file.
> So simply remove ioctl.o from the Makefile to fix.

$ git cat-file blob v3.9.2:fs/ceph/ioctl.c | wc -l
285
$ git cat-file blob v3.9.5:fs/ceph/ioctl.c | wc -l
285

Didn't you just, somehow, delete fs/ceph/ioctl.c locally?


Paul Bolle

