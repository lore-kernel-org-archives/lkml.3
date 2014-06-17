Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964831AbaFQXK5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 19:10:57 -0400
Received: from fgwmail4.fujitsu.co.jp ([164.71.1.141]:54305 "EHLO
	fgwmail4.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755233AbaFQXKz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 19:10:55 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v2.0.1
X-SHieldMailCheckerPolicyVersion: FJ-ISEC-20120718-4
Message-ID: <53A0CAE6.9030805@jp.fujitsu.com>
Date: Wed, 18 Jun 2014 08:10:30 +0900
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>,
        Gui Hecheng <guihc.fnst@cn.fujitsu.com>
CC: <linux-kernel@vger.kernel.org>, <linux-btrfs@vger.kernel.org>,
        <akpm@linux-foundation.org>
Subject: Re: [PATCH v4] lib: add size unit t/p/e to memparse
References: <1402623746-1171-1-git-send-email-guihc.fnst@cn.fujitsu.com> <alpine.DEB.2.02.1406171520510.517@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.02.1406171520510.517@chino.kir.corp.google.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-SecurityPolicyCheck-GC: OK by FENCE-Mail
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Gui,

(2014/06/18 7:21), David Rientjes wrote:
> On Fri, 13 Jun 2014, Gui Hecheng wrote:
>
>> For modern filesystems such as btrfs, t/p/e size level operations
>> are common.
>> add size unit t/p/e parsing to memparse
>>
>> Signed-off-by: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
>
> Acked-by: David Rientjes <rientjes@google.com>

It looks good to me.

Reviewed-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>

Thanks,
Satoru

>
> Sorry, didn't do this before.  Good luck with the simple_strto*() work!
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

