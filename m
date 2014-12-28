Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751633AbaL1FuW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2014 00:50:22 -0500
Received: from mail-wi0-f173.google.com ([209.85.212.173]:37276 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751045AbaL1FuT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2014 00:50:19 -0500
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <CACna6rz4ue2PFQR-=nKxmCJSw9O8pKU=S7LqxA68OY1D0obvKg@mail.gmail.com>
References: <1419708268-14114-1-git-send-email-oscar.forner.martinez@gmail.com>
	<CACna6rz4ue2PFQR-=nKxmCJSw9O8pKU=S7LqxA68OY1D0obvKg@mail.gmail.com>
Date: Sun, 28 Dec 2014 06:50:16 +0100
Message-ID: <CA+icZUVm6YNK_eN7-NcSH-mAqC61vwYryVUJuNMCKuhq8kXV2g@mail.gmail.com>
Subject: Re: [PATCH] bcma: fix three coding style issues, more than 80
 characters per line
From: Sedat Dilek <sedat.dilek@gmail.com>
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: Oscar Forner Martinez <oscar.forner.martinez@gmail.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 28, 2014 at 12:44 AM, Rafał Miłecki <zajec5@gmail.com> wrote:
> On 27 December 2014 at 20:24, Oscar Forner Martinez
> <oscar.forner.martinez@gmail.com> wrote:
>> Three lines with more than 80 characters per line have been split in several lines.
>>
>> Signed-off-by: Oscar Forner Martinez <oscar.forner.martinez@gmail.com>
>
> Acked-by: Rafał Miłecki <zajec5@gmail.com>
>

As for the comment-line changes... 80+ chars are allowed for better readability.
So, please don't do that.
[ Checkpatch should not warn on this especially for comments. ]

- Sedat -

> Kalle: will you pick this patch?
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
