Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752499AbbANRKf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 12:10:35 -0500
Received: from mail-pd0-f182.google.com ([209.85.192.182]:64375 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752002AbbANRKd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 12:10:33 -0500
MIME-Version: 1.0
In-Reply-To: <CAECXXi4mEV2=-w95LJCDA=zf6f8_SCRBHYkp2tTwUuAJiOjaQQ@mail.gmail.com>
References: <CAECXXi7Ax3t2b7x=KqUF1udNKWgQnGebVtkyLHnjhxEZ2o=M5g@mail.gmail.com>
	<CANZNk812oKH3k+bW8Jb2fQHxOS+pF=ghHpekB4X8QtQm67X-hQ@mail.gmail.com>
	<CAECXXi4mEV2=-w95LJCDA=zf6f8_SCRBHYkp2tTwUuAJiOjaQQ@mail.gmail.com>
Date: Wed, 14 Jan 2015 19:10:33 +0200
Message-ID: <CANZNk82ProX+XOBS+JF_LOPG0=7gvKe2ET_nLZ28quF+UJu=Uw@mail.gmail.com>
Subject: Re: NBD Maintainer
From: Andrey Utkin <andrey.krieger.utkin@gmail.com>
To: Paul Clements <paul.clements@us.sios.com>
Cc: kernel list <linux-kernel@vger.kernel.org>,
        "nbd-general@lists.sourceforge.net" 
	<nbd-general@lists.sourceforge.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2015-01-13 21:26 GMT+02:00 Paul Clements <paul.clements@us.sios.com>:
>> - what are critical bugs or important issues requiring work, if there are any.
>
> There is a network timeout issue, which is probably one of the more
> important fixes to get in:
>
> https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=770479

Looking at the proposed patch, it looks quite smart, and looking good
as long as it is tested. Going to test that ASAP.

-- 
Andrey Utkin
