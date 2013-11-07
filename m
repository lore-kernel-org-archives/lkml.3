Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751585Ab3KGFuw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 00:50:52 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:8534 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750970Ab3KGFui (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 00:50:38 -0500
X-IronPort-AV: E=Sophos;i="4.93,650,1378828800"; 
   d="scan'208";a="8969143"
Message-ID: <527B2A69.4070507@cn.fujitsu.com>
Date: Thu, 07 Nov 2013 13:51:37 +0800
From: Gao feng <gaofeng@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Richard Guy Briggs <rgb@redhat.com>
CC: Li Zefan <lizefan@huawei.com>, toshi.okajima@jp.fujitsu.com,
        containers@lists.linux-foundation.org, serge.hallyn@ubuntu.com,
        linux-kernel@vger.kernel.org, eparis@redhat.com,
        linux-audit@redhat.com, ebiederm@xmission.com, sgrubb@redhat.com
Subject: Re: [RFC Part1 PATCH 00/20 v2] Add namespace support for audit
References: <1382599925-25143-1-git-send-email-gaofeng@cn.fujitsu.com> <5271D3FC.8000709@cn.fujitsu.com> <5278A39B.6000303@cn.fujitsu.com> <5278A3D5.3010309@cn.fujitsu.com> <5278A828.50406@huawei.com> <5278B2D7.6060409@cn.fujitsu.com> <20131105191459.GF24236@madcap2.tricolour.ca>
In-Reply-To: <20131105191459.GF24236@madcap2.tricolour.ca>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/11/07 13:48:36,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/11/07 13:48:40,
	Serialize complete at 2013/11/07 13:48:40
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/06/2013 03:14 AM, Richard Guy Briggs wrote:
> On Tue, Nov 05, 2013 at 04:56:55PM +0800, Gao feng wrote:
>> On 11/05/2013 04:11 PM, Li Zefan wrote:
>>> On 2013/11/5 15:52, Gao feng wrote:
>>>> On 11/05/2013 03:51 PM, Gao feng wrote:
>>>>> Ping...
>>>>
>>>> I want to catch up the merge window..
>>>
>>> Even if your patches are accepted by a certain maintainer immediately,
>>> he will in no doubt queue them for 3.14.
>>
>> Yes, you are right...
>> But I still want to get some comments..
> 
> Definitely won't make it in in this merge window.  I agree it needs
> discussion, but I won't start that for at least another week (I'm
> currently at IETF in Vancouver.).
> 

Get it,hope we can start discussion ASAP.

Thanks
