Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030213Ab3FTLA0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 07:00:26 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:65146 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965287Ab3FTLAV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 07:00:21 -0400
X-AuditID: cbfee68f-b7f436d000000f81-fd-51c2e0ac2838
Message-id: <51C2E0AD.8060208@samsung.com>
Date: Thu, 20 Jun 2013 19:59:57 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: rjw@sisk.pl, linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>
Subject: Re: [PATCH v2] cpufreq: stats: Add 'load_table' debugfs file to show
 accumulated data of CPUs
References: <1371716524-19370-1-git-send-email-cw00.choi@samsung.com>
 <CAKohponD5s6-g0X9rgsVt0U4RutfyXSQJRZP3vT7EuczgMMQ2Q@mail.gmail.com>
 <51C2DD3D.5040601@samsung.com>
 <CAKohpomx54Y3WVToYP0nOw-hsxKzGjp2nyfzWf5bo1s530Yg1w@mail.gmail.com>
In-reply-to: <CAKohpomx54Y3WVToYP0nOw-hsxKzGjp2nyfzWf5bo1s530Yg1w@mail.gmail.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrFIsWRmVeSWpSXmKPExsWyRsSkSHfNg0OBBlsXmVmcbXrDbnF51xw2
	i9uNK9gs+hf2Mlls/OrhwOpx59oeNo++LasYPR4tbmH0+LxJLoAlissmJTUnsyy1SN8ugStj
	yhKfgitsFfsW/WFuYNzA2sXIySEhYCLx7dYEFghbTOLCvfVsXYxcHEICSxklzvxbztjFyAFW
	NHV7EEiNkMAiRon/P+sgal4wSnzeeIUNJMEroCUxfcYVsKEsAqoS576tBYuzAcX3v7gBZosK
	hEmsnH6FBaJeUOLH5HssIPNFgGpe3kwFCTMLtDJKXDjoCRIWFsiQmPC2CmLtF0aJc+eDQWxO
	gWCJpXMms0OU60jsb53GBmHLS2xe85YZ5DQJgU3sErPnNzNBnCMg8W3yIRaIV2QlNh1ghnhX
	UuLgihssExjFZiE5aBaSsbOQjF3AyLyKUTS1ILmgOCm9yFivODG3uDQvXS85P3cTIzCeTv97
	1r+D8e4B60OMyUArJzJLiSbnA+MxryTe0NjMyMLUxNTYyNzSjDRhJXFetRbrQCGB9MSS1OzU
	1ILUovii0pzU4kOMTBycUg2Mwv0JNRUP1c1iZmya/b7F6PctnR/fWl8bdiw6JHOLT1K7+a+k
	XOmhsn2bi1+o97zs8mgXifu98r/C68/FjS/WcsuzPbb/uKX+a3OpttupTmnX0PqwCV7Bt7Na
	2B8WP2/puP6uv3Pp+n87fnfuYZFya9VayOojmzNrjnKRy4/nKtH7JJdVBnEosRRnJBpqMRcV
	JwIAZmj1hr0CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpnleLIzCtJLcpLzFFi42I5/e+xgO6aB4cCDTZ/07M42/SG3eLyrjls
	FrcbV7BZ9C/sZbLY+NXDgdXjzrU9bB59W1Yxejxa3MLo8XmTXABLVAOjTUZqYkpqkUJqXnJ+
	SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7QXiWFssScUqBQQGJxsZK+HaYJ
	oSFuuhYwjRG6viFBcD1GBmggYQ1jxpQlPgVX2Cr2LfrD3MC4gbWLkYNDQsBEYur2oC5GTiBT
	TOLCvfVsILaQwCJGif8/67oYuYDsF4wSnzdeAUvwCmhJTJ9xhRXEZhFQlTj3bS1YnA0ovv/F
	DTBbVCBMYuX0KywQ9YISPybfYwHZJQJU8/JmKkiYWaCVUeLCQU+QsLBAhsSEt1UQa78wSpw7
	HwxicwoESyydM5kdolxHYn/rNDYIW15i85q3zBMYBWYhWTALSdksJGULGJlXMYqmFiQXFCel
	5xrpFSfmFpfmpesl5+duYgRH6zPpHYyrGiwOMQpwMCrx8GpcPhgoxJpYVlyZe4hRgoNZSYQ3
	dc6hQCHelMTKqtSi/Pii0pzU4kOMyUD/T2SWEk3OByaSvJJ4Q2MTMyNLI3NDCyNjc9KElcR5
	D7ZaBwoJpCeWpGanphakFsFsYeLglGpgnC72e09RR7K2c/TjYql337T1XzuEJysKu05z+Wb6
	6NyHKuVrR1y3ZH3jLV8R/fUlh5XcW4Ev85euuTHzzJMXjFPXr5vrfHkrf9b2z3zWN6ds2P3j
	+e2EKR237hQ7tVsq1Mf3zEwvrX5ptnGDHrvjlEqXmcVvjq873X+2IOCsrUkk0+9wed5DIkos
	xRmJhlrMRcWJAIQY2L4aAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/20/2013 07:55 PM, Viresh Kumar wrote:
> On 20 June 2013 16:15, Chanwoo Choi <cw00.choi@samsung.com> wrote:
>> Yes, freq->old is same freq->new.
>>
>> The cpufreq gorvernor(dbs_check_cpu()) send CPUFREQ_LOADCHECK noti
>> right after calculating CPUs load, regardless of changing CPU frequency.
>> So, I use only freq->old value without using freq->new because load_table
>> debugfs file need current cpu frequency.
>>
>> Now, I can't think of any proper usage for freq->new.
>> Do you have good way for using freq->new to include more useful data in load_table?
> 
> This information might be interesting.. At what load, we moved from
> which freq to which one..
> 
> Just see if you can add the notification after frequency has been
> changed.
> 
OK, I'll modify it and send test result. Thanks.

Best Regards,
Chanwoo Choi
