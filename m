Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753505Ab3KEIz4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 03:55:56 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:16485 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750719Ab3KEIzy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 03:55:54 -0500
X-IronPort-AV: E=Sophos;i="4.93,638,1378828800"; 
   d="scan'208";a="8951173"
Message-ID: <5278B2D7.6060409@cn.fujitsu.com>
Date: Tue, 05 Nov 2013 16:56:55 +0800
From: Gao feng <gaofeng@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Li Zefan <lizefan@huawei.com>
CC: toshi.okajima@jp.fujitsu.com, containers@lists.linux-foundation.org,
        serge.hallyn@ubuntu.com, linux-kernel@vger.kernel.org,
        eparis@redhat.com, Richard Guy Briggs <rgb@redhat.com>,
        linux-audit@redhat.com, ebiederm@xmission.com, sgrubb@redhat.com
Subject: Re: [RFC Part1 PATCH 00/20 v2] Add namespace support for audit
References: <1382599925-25143-1-git-send-email-gaofeng@cn.fujitsu.com> <5271D3FC.8000709@cn.fujitsu.com> <5278A39B.6000303@cn.fujitsu.com> <5278A3D5.3010309@cn.fujitsu.com> <5278A828.50406@huawei.com>
In-Reply-To: <5278A828.50406@huawei.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/11/05 16:53:59,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/11/05 16:54:00,
	Serialize complete at 2013/11/05 16:54:00
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/05/2013 04:11 PM, Li Zefan wrote:
> On 2013/11/5 15:52, Gao feng wrote:
>> On 11/05/2013 03:51 PM, Gao feng wrote:
>>> Ping...
>>>
>>
>> I want to catch up the merge window..
>>
> 
> Even if your patches are accepted by a certain maintainer immediately,
> he will in no doubt queue them for 3.14.
> 

Yes, you are right...
But I still want to get some comments..

