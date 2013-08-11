Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754022Ab3HKPEd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Aug 2013 11:04:33 -0400
Received: from mail-pb0-f45.google.com ([209.85.160.45]:33787 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753830Ab3HKPEb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Aug 2013 11:04:31 -0400
MIME-Version: 1.0
X-Originating-IP: [114.39.103.74]
In-Reply-To: <20130811144206.GC6427@sirena.org.uk>
References: <1376065558.7023.1.camel@phoenix>
	<20130809164100.GL6427@sirena.org.uk>
	<CAFRkauABN3JihU5jynbXqh6VRvM7-P8HFWAqFPOYMDL=xa0hcg@mail.gmail.com>
	<20130811144206.GC6427@sirena.org.uk>
Date: Sun, 11 Aug 2013 23:04:31 +0800
Message-ID: <CAFRkauCXrwHD=ZSLsvE9ZQkDcqcxVhB4tU1PUWbv5wihoS48Vg@mail.gmail.com>
Subject: Re: [PATCH] regulator: da9210: Remove redundant MODULE_ALIAS
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@kernel.org>
Cc: Steve Twiss <stwiss.opensource@diasemi.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/8/11 Mark Brown <broonie@kernel.org>:
> On Sat, Aug 10, 2013 at 10:13:23AM +0800, Axel Lin wrote:
>> 2013/8/10 Mark Brown <broonie@kernel.org>:
>> > On Sat, Aug 10, 2013 at 12:25:58AM +0800, Axel Lin wrote:
>
>> >> -MODULE_AUTHOR("S Twiss <stwiss.opensource@diasemi.com>");
>> >> +MODULE_AUTHOR("Steve Twiss <stwiss.opensource@diasemi.com>");
>
>> > It's perfectly reasonable for someone to want to be referred to by their
>> > initial, or their full spelled out name, or a nickname, or...
>
>> Oh, I didn't realize that naming could be intentional....
>> If Steve does not confirm this fix is good, I'll send a v2.
>
> Think JK Rowling or CS Lewis :)

Haha, Probably just because I speak Mandarin and I don't really understand the
English naming rule. I'm sending v2 right now.

Axel
