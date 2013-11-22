Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756037Ab3KVV7j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 16:59:39 -0500
Received: from mail-ve0-f182.google.com ([209.85.128.182]:44953 "EHLO
	mail-ve0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755503Ab3KVV7h convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 16:59:37 -0500
MIME-Version: 1.0
In-Reply-To: <CAGG-pURFGv2my_u8Okv5bft1SzpyGH8ccYYonjTFuZ7D=92x1g@mail.gmail.com>
References: <CAGG-pURFGv2my_u8Okv5bft1SzpyGH8ccYYonjTFuZ7D=92x1g@mail.gmail.com>
Date: Fri, 22 Nov 2013 22:59:36 +0100
Message-ID: <CAFLxGvyWxp5a6M6hEbFQLUaRAxNp9nYGYoj=rX33ewPsipBSZg@mail.gmail.com>
Subject: Re: [RFC PATCH] double free in decompressor.c
From: Richard Weinberger <richard.weinberger@gmail.com>
To: =?ISO-8859-1?Q?Geyslan_Greg=F3rio_Bem?= <geyslan@gmail.com>
Cc: phillip@squashfs.org.uk, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 22, 2013 at 10:50 PM, Geyslan Gregório Bem
<geyslan@gmail.com> wrote:
> Coverity caught double free possibility (CID 1130962).

Just wondering, where can one find/verify such CIDs?

-- 
Thanks,
//richard
