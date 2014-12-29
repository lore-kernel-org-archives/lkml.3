Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751957AbaL2HQh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2014 02:16:37 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:51691 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750994AbaL2HQf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2014 02:16:35 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: =?utf-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Cc: Oscar Forner Martinez <oscar.forner.martinez@gmail.com>,
        "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] bcma: fix three coding style issues, more than 80 characters per line
References: <1419708268-14114-1-git-send-email-oscar.forner.martinez@gmail.com>
	<CACna6rz4ue2PFQR-=nKxmCJSw9O8pKU=S7LqxA68OY1D0obvKg@mail.gmail.com>
Date: Mon, 29 Dec 2014 09:16:29 +0200
In-Reply-To: <CACna6rz4ue2PFQR-=nKxmCJSw9O8pKU=S7LqxA68OY1D0obvKg@mail.gmail.com>
	(=?utf-8?Q?=22Rafa=C5=82_Mi=C5=82ecki=22's?= message of "Sun, 28 Dec 2014
 00:44:20 +0100")
Message-ID: <8761cv6i42.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafał Miłecki <zajec5@gmail.com> writes:

> On 27 December 2014 at 20:24, Oscar Forner Martinez
> <oscar.forner.martinez@gmail.com> wrote:
>> Three lines with more than 80 characters per line have been split in several lines.
>>
>> Signed-off-by: Oscar Forner Martinez <oscar.forner.martinez@gmail.com>
>
> Acked-by: Rafał Miłecki <zajec5@gmail.com>
>
> Kalle: will you pick this patch?

Most likely yes, but let's wait first for John's opinion about how to
handle bcma patches.

-- 
Kalle Valo
