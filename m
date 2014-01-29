Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751954AbaA2Lzn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 06:55:43 -0500
Received: from mail-vb0-f52.google.com ([209.85.212.52]:40813 "EHLO
	mail-vb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750936AbaA2Lzl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 06:55:41 -0500
MIME-Version: 1.0
In-Reply-To: <20140129114027.GX11841@sirena.org.uk>
References: <1390968181-31800-1-git-send-email-badarkhe.manish@gmail.com>
	<1390968181-31800-2-git-send-email-badarkhe.manish@gmail.com>
	<1390969124.11756.43.camel@joe-AO722>
	<CAKDJKT7ZpH89k6a4yfbBt+dpQ3oM9Khe42VwFmEjKqmu55jNzw@mail.gmail.com>
	<20140129114027.GX11841@sirena.org.uk>
Date: Wed, 29 Jan 2014 17:25:40 +0530
Message-ID: <CAKDJKT7xSscxGaRrLqQYtNv6c86iV0i8h+OFaspyp3fkPsHyKg@mail.gmail.com>
Subject: Re: [PATCH V3 1/2] devres: introduce API "devm_kstrdup"
From: Manish Badarkhe <badarkhe.manish@gmail.com>
To: Mark Brown <broonie@kernel.org>
Cc: Joe Perches <joe@perches.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        gregkh@linuxfoundation.org, Liam Girdwood <lgirdwood@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Wed, Jan 29, 2014 at 5:10 PM, Mark Brown <broonie@kernel.org> wrote:
> On Wed, Jan 29, 2014 at 04:38:20PM +0530, Manish Badarkhe wrote:
>> On Wed, Jan 29, 2014 at 9:48 AM, Joe Perches <joe@perches.com> wrote:
>
>> >> +     buf = devm_kzalloc(dev, size, gfp);
>
>> > If this is really necessary, please use devm_kmalloc
>
>> devm_kzalloc is always better giving zeroed memory locations.
>> Is there any reason not to go for it?
>
> If the allocated memory is going to be immediately overwritten with the
> string then it shouldn't make any difference if it was zeroed when
> allocated.

Thank you for clarification. I will go ahead to make it devm_kmalloc
and post a new version of patch.

Regards
Manish Badarkhe
