Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755747Ab3E0B2K (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 May 2013 21:28:10 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:52938 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755677Ab3E0B2J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 May 2013 21:28:09 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.8.9
X-SHieldMailCheckerPolicyVersion: FJ-ISEC-20120718-2
Message-ID: <51A2B693.7000701@jp.fujitsu.com>
Date: Mon, 27 May 2013 10:27:47 +0900
From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Zhang Yanfei <zhangyanfei.yes@gmail.com>
CC: "Eric W. Biederman" <ebiederm@xmission.com>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Simon Horman <horms@verge.net.au>, "H. Peter Anvin" <hpa@zytor.com>,
        davej@redhat.com, Andrew Morton <akpm@linux-foundation.org>,
        Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH 2/7] Documentation/devices.txt: Remove /dev/oldmem description
References: <51A02E50.5020507@gmail.com> <51A02F59.8000103@gmail.com> <87vc668x4w.fsf@xmission.com> <51A15E2F.7010308@gmail.com>
In-Reply-To: <51A15E2F.7010308@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/05/26 9:58), Zhang Yanfei wrote:
> 于 2013年05月26日 07:20, Eric W. Biederman 写道:
>> Zhang Yanfei <zhangyanfei.yes@gmail.com> writes:
>>
>>> From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
>>
>> Won't we want to keep this reservation around to so that this number
>> doesn't get reused, and cause people confusion when
>> upgrading/downgrading kernels?
>
> Ah, yes. I will just keep this and add a note to make people know that
> it is removed in the next version.
>

It looks enough writing "obsolete" according to the other parts of the same file.

-- 
Thanks.
HATAYAMA, Daisuke

