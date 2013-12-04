Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753546Ab3LDGoT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 01:44:19 -0500
Received: from mail-pd0-f180.google.com ([209.85.192.180]:43747 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751238Ab3LDGoR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 01:44:17 -0500
MIME-Version: 1.0
X-Originating-IP: [111.240.61.77]
In-Reply-To: <1386125959.1974.309@driftwood>
References: <1384589723.7840.1.camel@phoenix>
	<1386125959.1974.309@driftwood>
Date: Wed, 4 Dec 2013 14:44:14 +0800
Message-ID: <CAFRkauAzR=BqJGrMzN0i-tvi5mcQvyB9Kihk0YvxMpk=SWGvFA@mail.gmail.com>
Subject: Re: [PATCH] devtmpfs: Calling delete_path() only when necessary
From: Axel Lin <axel.lin@ingics.com>
To: Rob Landley <rob@landley.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Kay Sievers <kay.sievers@vrfy.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/12/4 Rob Landley <rob@landley.net>:
> On 11/16/2013 02:15:23 AM, Axel Lin wrote:
>>
>> The deleted variable is always 1 in current code.
>> Initialize deleted variable to be 0, so delete_path() will be called only
>> when
>> necessary.
>>
>> Signed-off-by: Axel Lin <axel.lin@ingics.com>
>
>
> I'm not seeing this in linux-next, or a reply on the web archive. Assuming
> nobody's objected to this, you might want to forward it to
> trivial@kernel.org.
>
> That said, you could describe what it _does_ a little more?

I was expecting Greg to pick up this patch.

I thought the description is pretty clear.
What the patch does is changing the init value of deleted variable to 0.
The intention of this change is to avoid unnecessary delete_path() call.

Hi Greg,
Would you pick up this patch?
If a re-send or a v2 is required, please just let me know.

Thanks,
Axel
