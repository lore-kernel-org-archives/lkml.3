Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933075Ab3E1G2O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 02:28:14 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:34602 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S933008Ab3E1G2N convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 02:28:13 -0400
X-IronPort-AV: E=Sophos;i="4.87,756,1363104000"; 
   d="scan'208";a="7387164"
Message-ID: <51A44DD5.5050301@cn.fujitsu.com>
Date: Tue, 28 May 2013 14:25:25 +0800
From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.8) Gecko/20121012 Thunderbird/10.0.8
MIME-Version: 1.0
To: Rob Landley <rob@landley.net>
CC: "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>,
        Simon Horman <horms@verge.net.au>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Vivek Goyal <vgoyal@redhat.com>,
        Zhang Yanfei <zhangyanfei.yes@gmail.com>
Subject: Re: [PATCH v2 2/7] Documentation/devices.txt: Mark /dev/oldmem obsolete
References: <1369721851.2776.37@driftwood>
In-Reply-To: <1369721851.2776.37@driftwood>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/05/28 14:26:34,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/05/28 14:26:38
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/28/2013 02:17 PM, Rob Landley wrote:
> On 05/26/2013 08:54:19 PM, Zhang Yanfei wrote:
>> 于 2013年05月27日 09:46, HATAYAMA Daisuke 写道:
>> > (2013/05/26 15:36), Zhang Yanfei wrote:
>> >> From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
>> >>
>> >> Signed-off-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
>> >> Cc: Dave Jones <davej@redhat.com>
>> >> ---
>> >>   Documentation/devices.txt |    3 +--
>> >>   1 files changed, 1 insertions(+), 2 deletions(-)
>> >>
>> >> diff --git a/Documentation/devices.txt b/Documentation/devices.txt
>> >> index 08f01e7..c8e4002 100644
>> >> --- a/Documentation/devices.txt
>> >> +++ b/Documentation/devices.txt
>> >> @@ -100,8 +100,7 @@ Your cooperation is appreciated.
>> >>            10 = /dev/aio        Asynchronous I/O notification interface
>> >>            11 = /dev/kmsg        Writes to this come out as printk's, reads
>> >>                       export the buffered printk records.
>> >> -         12 = /dev/oldmem    Used by crashdump kernels to access
>> >> -                    the memory of the kernel that crashed.
>> >> +         12 = /dev/oldmem    OBSOLETE
>> >>
>> >>     1 block    RAM disk
>> >>             0 = /dev/ram0        First RAM disk
>> >>
>> >
>> > This is the new patch. Looking at other parts of devices.txt, obsolete is
>> > sometimes used together with unused. I guess obsolete means this is old interface so
>> > don't use it as much as possible and unused means this is not used at all now.
>> > You remove old memory interface completely in this patch set, so is it better to add
>> > unused, too?
>> >
>>
>> Does obsolete also mean "not used anymore"? I don't know. I think we can wait for some native
>> English speakers to comment on this.
> 
> Obsolete implies that it shouldn't be used anymore. There are exceptions to everything, of course...
> 
> (Unused means nothing is using it. If there's still code using it, it's not unused. So yeah unused would imply removed.)
> 

So, could I just use UNSED to replace OBSOLETE here? Or use "OBSOLETE/UNUSED"?

-- 
Thanks.
Zhang Yanfei
