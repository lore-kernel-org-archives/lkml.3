Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755754Ab3E0Bag (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 May 2013 21:30:36 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:21481 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755669Ab3E0Baf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 May 2013 21:30:35 -0400
X-IronPort-AV: E=Sophos;i="4.87,747,1363104000"; 
   d="scan'208";a="7373529"
Message-ID: <51A2B68E.4060605@cn.fujitsu.com>
Date: Mon, 27 May 2013 09:27:42 +0800
From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.8) Gecko/20121012 Thunderbird/10.0.8
MIME-Version: 1.0
To: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
CC: Zhang Yanfei <zhangyanfei.yes@gmail.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Simon Horman <horms@verge.net.au>, "H. Peter Anvin" <hpa@zytor.com>,
        davej@redhat.com, Andrew Morton <akpm@linux-foundation.org>,
        Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH 2/7] Documentation/devices.txt: Remove /dev/oldmem description
References: <51A02E50.5020507@gmail.com> <51A02F59.8000103@gmail.com> <87vc668x4w.fsf@xmission.com> <51A15E2F.7010308@gmail.com> <51A2B693.7000701@jp.fujitsu.com>
In-Reply-To: <51A2B693.7000701@jp.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/05/27 09:28:51,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/05/27 09:29:04
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2013年05月27日 09:27, HATAYAMA Daisuke 写道:
> (2013/05/26 9:58), Zhang Yanfei wrote:
>> 于 2013年05月26日 07:20, Eric W. Biederman 写道:
>>> Zhang Yanfei <zhangyanfei.yes@gmail.com> writes:
>>>
>>>> From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
>>>
>>> Won't we want to keep this reservation around to so that this number
>>> doesn't get reused, and cause people confusion when
>>> upgrading/downgrading kernels?
>>
>> Ah, yes. I will just keep this and add a note to make people know that
>> it is removed in the next version.
>>
> 
> It looks enough writing "obsolete" according to the other parts of the same file.
> 

I've sent the v2 version and actually did what you said.

Thanks
Zhang
