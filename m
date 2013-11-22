Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756245Ab3KVWOc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 17:14:32 -0500
Received: from mail-ie0-f179.google.com ([209.85.223.179]:54231 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753714Ab3KVWOa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 17:14:30 -0500
MIME-Version: 1.0
In-Reply-To: <CAFLxGvyWxp5a6M6hEbFQLUaRAxNp9nYGYoj=rX33ewPsipBSZg@mail.gmail.com>
References: <CAGG-pURFGv2my_u8Okv5bft1SzpyGH8ccYYonjTFuZ7D=92x1g@mail.gmail.com>
	<CAFLxGvyWxp5a6M6hEbFQLUaRAxNp9nYGYoj=rX33ewPsipBSZg@mail.gmail.com>
Date: Fri, 22 Nov 2013 20:14:29 -0200
Message-ID: <CAGG-pURRFRahZb093oknP3bFfKZ+Sq3VN6xapEi2ZkDy=MqoVg@mail.gmail.com>
Subject: Re: [RFC PATCH] double free in decompressor.c
From: =?ISO-8859-1?Q?Geyslan_Greg=F3rio_Bem?= <geyslan@gmail.com>
To: Richard Weinberger <richard.weinberger@gmail.com>
Cc: phillip@squashfs.org.uk, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/11/22 Richard Weinberger <richard.weinberger@gmail.com>:
> On Fri, Nov 22, 2013 at 10:50 PM, Geyslan Gregório Bem
> <geyslan@gmail.com> wrote:
>> Coverity caught double free possibility (CID 1130962).
>
> Just wondering, where can one find/verify such CIDs?
>
> --
> Thanks,
> //richard

Anyone can sign in (https://scan.coverity.com/) and choose an open
source project or register one (as maintainer) indeed. After that,
configure to receive "new defects" updates.

-- 
Regards,

Geyslan G. Bem
hackingbits.com
