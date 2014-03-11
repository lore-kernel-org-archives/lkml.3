Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753255AbaCKM6g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 08:58:36 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:20190 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752032AbaCKM6f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 08:58:35 -0400
X-IronPort-AV: E=Sophos;i="4.97,629,1389715200"; 
   d="scan'208";a="9678915"
Message-ID: <531F0806.6070004@cn.fujitsu.com>
Date: Tue, 11 Mar 2014 20:56:38 +0800
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130612 Thunderbird/17.0.6
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: linux-kernel@vger.kernel.org, peterz@infradead.org, joe@perches.com,
        mingo@kernel.org, tglx@linutronix.de, heiko.carstens@de.ibm.com
Subject: Re: [PATCH 04/17] workqueue: Replace hardcoding of -20 with MIN_NICE.
References: <cover.1394532288.git.yangds.fnst@cn.fujitsu.com> <ff13819fd09b7a5dba5ab5ae797f2e7019bdfa17.1394532288.git.yangds.fnst@cn.fujitsu.com> <20140311122225.GB11477@htj.dyndns.org> <20140311125529.GE11477@htj.dyndns.org>
In-Reply-To: <20140311125529.GE11477@htj.dyndns.org>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/03/11 20:55:46,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/03/11 20:55:47,
	Serialize complete at 2014/03/11 20:55:47
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tejun,

On 03/11/2014 08:55 PM, Tejun Heo wrote:
> On Tue, Mar 11, 2014 at 08:22:25AM -0400, Tejun Heo wrote:
>> On Tue, Mar 11, 2014 at 06:09:12PM +0800, Dongsheng Yang wrote:
>>> Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
>>> cc: Tejun Heo <tj@kernel.org>
>> Applied to wq/for-3.15.
> And reverted as MIN_NICE is not defined yet.  Please feel free to add
> my Acked-by and route it together with the prerequisite changes.

The MIN_NICE is just in tip tree for now. So I think this patch should
go through tip.

Thank you for your ack.
>
> Thanks.
>

