Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755543Ab3JXRVC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 13:21:02 -0400
Received: from mail-wg0-f53.google.com ([74.125.82.53]:63676 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754055Ab3JXRVA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 13:21:00 -0400
MIME-Version: 1.0
In-Reply-To: <F901C6708ADD5241BD39AFE3DD266906013746E21BDC@seldmbx01.corpusers.net>
References: <1381273137-14680-1-git-send-email-tim.bird@sonymobile.com>
	<000001419e9e3e33-67807dca-e435-43ee-88bc-3ead54a83762-000000@email.amazonses.com>
	<F901C6708ADD5241BD39AFE3DD266906013746E21BDC@seldmbx01.corpusers.net>
Date: Thu, 24 Oct 2013 20:20:58 +0300
X-Google-Sender-Auth: q9e_JIvsuwQZbCSXHBIdzJZPDw4
Message-ID: <CAOJsxLG9_YZKq1Z4tdjmWKjNL3L1E7nXBhzPHNorUNF1U9q7mA@mail.gmail.com>
Subject: Re: [PATCH] slub: proper kmemleak tracking if CONFIG_SLUB_DEBUG disabled
From: Pekka Enberg <penberg@kernel.org>
To: "Bobniev, Roman" <Roman.Bobniev@sonymobile.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        "frowand.list@gmail.com" <frowand.list@gmail.com>,
        =?ISO-8859-1?Q?Andersson=2C_Bj=F6rn?= 
	<Bjorn.Andersson@sonymobile.com>,
        "tbird20d@gmail.com" <tbird20d@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Bird, Tim" <Tim.Bird@sonymobile.com>, "cl@linux.com" <cl@linux.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 23, 2013 at 2:52 PM, Bobniev, Roman
<Roman.Bobniev@sonymobile.com> wrote:
>> On Tue, 8 Oct 2013, Tim Bird wrote:
>>
>> > It also fixes a bug where kmemleak was only partially enabled in some
>> > configurations.
>>
>> Acked-by: Christoph Lameter <cl@linux.com>
>
> Could you help me, who the maintainer is that
> puts this patch in a tree and pushes it to mainline?
> Do we wait on some additional Ack from someone?

That would be me - sorry for the delay!

Applied, thanks!
