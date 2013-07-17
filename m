Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751221Ab3GQB2v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 21:28:51 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:51849 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750979Ab3GQB2t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 21:28:49 -0400
X-IronPort-AV: E=Sophos;i="4.89,678,1367942400"; 
   d="scan'208";a="7916263"
Message-ID: <51E5F03A.4060508@cn.fujitsu.com>
Date: Wed, 17 Jul 2013 09:15:38 +0800
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Benjamin LaHaise <bcrl@kvack.org>
CC: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
        Al Viro <viro@zeniv.linux.org.uk>, tangchen <tangchen@cn.fujitsu.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-mm@kvack.org,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Subject: Re: [PATCH RESEND 1/2] fs/anon_inode: Introduce a new lib function
 anon_inode_getfile_private()
References: <51E518BC.8040900@cn.fujitsu.com> <20130716131614.GC5403@kvack.org>
In-Reply-To: <20130716131614.GC5403@kvack.org>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/07/17 09:17:17,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/07/17 09:17:41,
	Serialize complete at 2013/07/17 09:17:41
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ben,

On 07/16/2013 09:16 PM, Benjamin LaHaise wrote:

> On Tue, Jul 16, 2013 at 05:56:12PM +0800, Gu Zheng wrote:
>>
>> Introduce a new lib function anon_inode_getfile_private(), it creates a new file
>> instance by hooking it up to an anonymous inode, and a dentry that describe the
>> "class" of the file, similar to anon_inode_getfile(), but each file holds a
>> single inode. Furthermore, anyone who wants to create a private anon file will
>> benefit from this change.
>>
>> Signed-off-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
>> Signed-off-by: Benjamin LaHaise <bcrl@kvack.org>
> 
> Please don't add my Signed-off-by when I have never even seen or reviewed 
> a patch -- that is completely unacceptable.  

Sorry for my reckless action, I'll remember your reminder.:)

> Second, I don't think this 
> patch is suitable for 3.11, as it has not seen much testing outside of one 
> test program I had written.  It's a long standing bug, so it isn't urgent 
> to get the fix into the tree.  That said, it did pass a few tests I ran 
> last night, so it is probably suitable for the -next tree.

Thanks for your test.:)

Regards,
Gu

> 
> As for patch 1, it looks okay to me, but will need Al Viro's signoff.
> 
> 		-ben


