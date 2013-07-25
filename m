Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756562Ab3GYP3x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 11:29:53 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:64646 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756489Ab3GYP3m convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 11:29:42 -0400
MIME-Version: 1.0
In-Reply-To: <51F14136.30409@mozilla.com>
References: <1374699833.7083.2.camel@localhost>
	<20130724233628.GD3641@logfs.org>
	<51F14136.30409@mozilla.com>
Date: Thu, 25 Jul 2013 16:29:41 +0100
Message-ID: <CAB3wodfp88G62YGU1hB_P4SSj3CiV3MjY1-Jn5FDr_GJ2KtYHQ@mail.gmail.com>
Subject: Re: [RFC/PATCH 0/2] ext4: Transparent Decompression Support
From: Phillip Lougher <phillip.lougher@gmail.com>
To: Dhaval Giani <dgiani@mozilla.com>
Cc: =?ISO-8859-1?Q?J=F6rn_Engel?= <joern@logfs.org>,
        linux-kernel@vger.kernel.org, tytso@mit.edu, tglek@mozilla.com,
        vdjeric@mozilla.com, glandium@mozilla.com, linux-ext4@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25 July 2013 16:16, Dhaval Giani <dgiani@mozilla.com> wrote:
> On 07/24/2013 07:36 PM, Jörn Engel wrote:

>
>> Assuming you use the chattr approach, that pretty much comes down to
>> adding compression support to ext4.  There have been old patches for
>> ext2 around that never got merged.  Reading up on the problems
>> encountered by those patches might be instructive.
>
>
> Do you have subjects for these? When I googled for ext4 compression, I found
> http://code.google.com/p/e4z/ which doesn't seem to exist, and checking in
> my LKML archives gives too many false positives.
>

The ext2 compression project was called e2compr, http://e2compr.sourceforge.net/

Also just google for "e2compr".

Phillip

> Thanks!
> Dhaval
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
>
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
