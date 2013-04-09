Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933610Ab3DIN7w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 09:59:52 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:60051 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751406Ab3DIN7u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 09:59:50 -0400
X-AuditID: cbfec7f5-b7fd76d000007247-fd-51641ed490c9
Message-id: <51641ED3.1090603@samsung.com>
Date: Tue, 09 Apr 2013 15:59:47 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-version: 1.0
To: Vivek Gautam <gautamvivek1987@gmail.com>
Cc: Vivek Gautam <gautam.vivek@samsung.com>, rtc-linux@googlegroups.com,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        a.zummo@towertech.it, kgene.kim@samsung.com, dianders@chromium.org,
        Thomas Abraham <thomas.ab@samsung.com>
Subject: Re: [PATCH RFC] rtc: rtc-s3c: use clk_prepare_enable and
 clk_disable_unprepare
References: <1365500744-14839-1-git-send-email-gautam.vivek@samsung.com>
 <5163E8EB.1050803@samsung.com>
 <CAFp+6iE-ZYSNHZBntTcX8fESLB2FXOr6idM8_Q3Rd7T3s_c4Dw@mail.gmail.com>
 <CAFp+6iGS-4iv-PKTKP4OhwVvTsDoPnc-9N-6AAr5x=Bz9r=vTw@mail.gmail.com>
In-reply-to: <CAFp+6iGS-4iv-PKTKP4OhwVvTsDoPnc-9N-6AAr5x=Bz9r=vTw@mail.gmail.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrLLMWRmVeSWpSXmKPExsVy+t/xK7pX5FICDc7uErZYcvEqu8XZZQfZ
	LNquHGS3ePt9C7tF74KrbBaXd81hs5hxfh+Txf7ODkaLjmWMDpwesxsusnjsnHWX3WPPxJNs
	Hn1bVjF6TJ/3k8nj8ya5ALYoLpuU1JzMstQifbsEroz51z4zF/xgrnh+6ANjA+NE5i5GTg4J
	AROJpkMXWCFsMYkL99azdTFycQgJLGWUOL12G1hCSOATo8Sa10ogNq+AlsSk43MYQWwWAVWJ
	7c1v2UBsNgFDid6jfWBxUYEAicVLzrFD1AtK/Jh8jwXEFhHQkTjU2s8CsoBZ4BejxPlnC8EW
	CAtESpzeMYkJYvN3Roktt5aBnccpECyxa80fsEnMQN37W6exQdjyEpvXvGWewCgwC8mSWUjK
	ZiEpW8DIvIpRNLU0uaA4KT3XSK84Mbe4NC9dLzk/dxMjJAq+7mBceszqEKMAB6MSD2/Fo6RA
	IdbEsuLK3EOMEhzMSiK8h6RSAoV4UxIrq1KL8uOLSnNSiw8xMnFwSjUwuuaHef7gDzT32D/p
	yNXX7zcHXdVmOzffIe7EpjNCRVKLOmZPWsHcV3p14xxBvab/zNO+Z8/KuLK3dj7DThXJ+VZ7
	Qr4p7rX58tzi0iPNS6dZu7bcm/JEXUC/++NNH8abC6Ojn1kVrlrhrm3ozFx1QHR/3I4asTOy
	Byf/F1xutWamlPnjn16M/5VYijMSDbWYi4oTAZI0cc5gAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/09/2013 03:34 PM, Vivek Gautam wrote:
>> Aah !! actually missed a similar patch from Thomas Abraham :(
>> > doing the same as suggested by you.
>> > Its available at:
>> > http://patchwork.ozlabs.org/patch/188687/
> There's a change required in the above mentioned patch, so possibly
> Thomas can go ahead and post the next version
> of that.

Why not make that change yourself if you need it ? That patch is
really old, maybe Thomas is busy with other things now.

Thanks,
Sylwester
