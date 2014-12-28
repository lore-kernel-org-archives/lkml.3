Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751765AbaL1Ixj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2014 03:53:39 -0500
Received: from mail-ie0-f170.google.com ([209.85.223.170]:61351 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751439AbaL1Ixi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2014 03:53:38 -0500
MIME-Version: 1.0
In-Reply-To: <CA+icZUVm6YNK_eN7-NcSH-mAqC61vwYryVUJuNMCKuhq8kXV2g@mail.gmail.com>
References: <1419708268-14114-1-git-send-email-oscar.forner.martinez@gmail.com>
	<CACna6rz4ue2PFQR-=nKxmCJSw9O8pKU=S7LqxA68OY1D0obvKg@mail.gmail.com>
	<CA+icZUVm6YNK_eN7-NcSH-mAqC61vwYryVUJuNMCKuhq8kXV2g@mail.gmail.com>
Date: Sun, 28 Dec 2014 09:53:36 +0100
Message-ID: <CACna6rymPy1+YtEHEk18ci3VaAWkiwJ2iWv+p_yYPAjzQeJwtw@mail.gmail.com>
Subject: Re: [PATCH] bcma: fix three coding style issues, more than 80
 characters per line
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Sedat Dilek <sedat.dilek@gmail.com>
Cc: Oscar Forner Martinez <oscar.forner.martinez@gmail.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28 December 2014 at 06:50, Sedat Dilek <sedat.dilek@gmail.com> wrote:
> On Sun, Dec 28, 2014 at 12:44 AM, Rafał Miłecki <zajec5@gmail.com> wrote:
>> On 27 December 2014 at 20:24, Oscar Forner Martinez
>> <oscar.forner.martinez@gmail.com> wrote:
>>> Three lines with more than 80 characters per line have been split in several lines.
>>>
>>> Signed-off-by: Oscar Forner Martinez <oscar.forner.martinez@gmail.com>
>>
>> Acked-by: Rafał Miłecki <zajec5@gmail.com>
>>
>
> As for the comment-line changes... 80+ chars are allowed for better readability.
> So, please don't do that.
> [ Checkpatch should not warn on this especially for comments. ]

We almost always split long comments into separated lines in the
kernel. What's different with this case?

-- 
Rafał
