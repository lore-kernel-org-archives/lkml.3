Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755670Ab3LDBV3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 20:21:29 -0500
Received: from mail-ve0-f171.google.com ([209.85.128.171]:33102 "EHLO
	mail-ve0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753306Ab3LDBVZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 20:21:25 -0500
MIME-Version: 1.0
In-Reply-To: <20131203181246.GD13712@localhost>
References: <20131203112032.b6c5faa3e40442b66770df91@canb.auug.org.au>
	<20131203155245.GA2893@tuxdriver.com>
	<1386086983.4393.38.camel@jlt4.sipsolutions.net>
	<20131203181246.GD13712@localhost>
Date: Wed, 4 Dec 2013 09:21:23 +0800
Message-ID: <CAEFj986GAiN=mx7mxZLxM5d1qq75xJaQLvBt0zHXB0Q0f6FJtg@mail.gmail.com>
Subject: Re: linux-next: manual merge of the wireless-next tree with the
 wireless tree
From: Yeoh Chun-Yeow <yeohchunyeow@gmail.com>
To: Bob Copeland <me@bobcopeland.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
        "John W. Linville" <linville@tuxdriver.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Bob Copeland <bob@cozybit.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> I think the above is correct, the pre_value assignment with 1/++ and
>> chsw_init moved into another function in Bob's patch. Bob?
>
> The quoted resolution looks right to me.  But, I think the patch
> in question was actually Chun-yeow's so I'm not sure my opinion
> counts :)

Yes, it is correct.

The chsw_init is moved by ""mac80211: fix the mesh channel switch
support" patch.

----
Chun-Yeow
