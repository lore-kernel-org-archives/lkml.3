Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751875Ab3EHFWg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 01:22:36 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:39291 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750719Ab3EHFWe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 01:22:34 -0400
X-IronPort-AV: E=Sophos;i="4.87,632,1363104000"; 
   d="scan'208";a="7213346"
Message-ID: <5189E188.6060801@cn.fujitsu.com>
Date: Wed, 08 May 2013 13:24:24 +0800
From: Gao feng <gaofeng@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130402 Thunderbird/17.0.5
MIME-Version: 1.0
To: Matt Helsley <matthltc@linux.vnet.ibm.com>
CC: viro@zeniv.linux.org.uk, eparis@redhat.com, ebiederm@xmission.com,
        sgrubb@redhat.com, akpm@linux-foundation.org, serge.hallyn@ubuntu.com,
        davem@davemloft.net, netdev@vger.kernel.org,
        containers@lists.linux-foundation.org, linux-audit@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC 10/48] Audit: change type of audit_ever_enabled to
 bool
References: <1367893269-9308-1-git-send-email-gaofeng@cn.fujitsu.com> <1367893269-9308-11-git-send-email-gaofeng@cn.fujitsu.com> <20130508020626.GD24627@us.ibm.com>
In-Reply-To: <20130508020626.GD24627@us.ibm.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/05/08 13:21:36,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/05/08 13:21:38,
	Serialize complete at 2013/05/08 13:21:38
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/08/2013 10:06 AM, Matt Helsley wrote:
> On Tue, May 07, 2013 at 10:20:31AM +0800, Gao feng wrote:
>> It's better to define audit_ever_enabled as bool
>>
>> Signed-off-by: Gao feng <gaofeng@cn.fujitsu.com>
>> ---
>>  kernel/audit.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/kernel/audit.c b/kernel/audit.c
>> index 4595a9e..1138ff5 100644
>> --- a/kernel/audit.c
>> +++ b/kernel/audit.c
>> @@ -76,7 +76,7 @@ static int	audit_initialized;
>>  #define AUDIT_OFF	0
>>  #define AUDIT_ON	1
>>  #define AUDIT_LOCKED	2
>> -int		audit_ever_enabled;
>> +bool		audit_ever_enabled;
> 
> I think you're better off placing this at the beginning of the series
> and submitting it separately since it's only incidentally related to
> this RFC.
> 

Thanks for your suggestion. will send these cleanup patches separately.

Thanks
Gao
