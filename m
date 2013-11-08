Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756436Ab3KHHGa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 02:06:30 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:37051 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756020Ab3KHHG1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 02:06:27 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,7252"; a="85764457"
Cc: Eugene Krasnikov <k.eugene.e@gmail.com>,
        "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        wcn36xx <wcn36xx@lists.infradead.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        <ath5k-devel@venema.h4ckr.net>,
        ath9k-devel <ath9k-devel@venema.h4ckr.net>,
        <ath10k@lists.infradead.org>, <wil6210@qca.qualcomm.com>
X-IronPort-AV: E=McAfee;i="5400,1158,7252"; a="580801674"
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Joe Perches <joe@perches.com>
Subject: Re: [PATCH] wcn36xx: Fix logging macro with unnecessary semicolon
References: <1383684000.4387.42.camel@joe-AO722>
	<CAFSJ42YQy96Sko8CuG9BGjHzTV7TkRp2=NVt036APxSKpPB=Ag@mail.gmail.com>
	<1383760556.7940.28.camel@joe-AO722>
	<CAFSJ42Y-3BZqj+JRNa8wdxjnm1fguD8ToH5Oj0m56yT5NexdVQ@mail.gmail.com>
	<1383853221.9263.14.camel@joe-AO722>
Date: Fri, 8 Nov 2013 09:06:19 +0200
In-Reply-To: <1383853221.9263.14.camel@joe-AO722> (Joe Perches's message of
	"Thu, 7 Nov 2013 11:40:21 -0800")
Message-ID: <87bo1vcqz8.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
X-Originating-IP: [172.30.48.1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Perches <joe@perches.com> writes:

>> have a
>> second round of convincing ath guys to change printing code. How does
>> that sound?
>
> Luis?  Kalle?  Other Qualcomm/Atheros folk?

I didn't quite get what you are asking from me. But for me most
important is that the current debugging facilities from user's point of
view don't change. I don't care if the code is in ath10k.ko or ath.ko,
we are talking about ~100 lines of code anyway.

> One of the nominal benefits of separating the ath_<level>
> macros by subsystem was perf/tracing.

Nominal?

-- 
Kalle Valo
