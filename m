Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936983Ab3DIISh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 04:18:37 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:64547 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S933440Ab3DIISe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 04:18:34 -0400
X-IronPort-AV: E=Sophos;i="4.87,438,1363104000"; 
   d="scan'208";a="7020697"
Message-ID: <5163CF82.8040806@cn.fujitsu.com>
Date: Tue, 09 Apr 2013 16:21:22 +0800
From: Tang Chen <tangchen@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
CC: rob@landley.net, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        yinghai@kernel.org, akpm@linux-foundation.org, wency@cn.fujitsu.com,
        trenn@suse.de, liwanp@linux.vnet.ibm.com, mgorman@suse.de,
        walken@google.com, riel@redhat.com, khlebnikov@openvz.org,
        tj@kernel.org, minchan@kernel.org, m.szyprowski@samsung.com,
        mina86@mina86.com, laijs@cn.fujitsu.com, linfeng@cn.fujitsu.com,
        kosaki.motohiro@jp.fujitsu.com, jiang.liu@huawei.com,
        guz.fnst@cn.fujitsu.com, x86@kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 00/11] Introduce movablemem_map=acpi boot option.
References: <1365154801-473-1-git-send-email-tangchen@cn.fujitsu.com> <5163A3BF.3030900@jp.fujitsu.com>
In-Reply-To: <5163A3BF.3030900@jp.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/04/09 16:17:21,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/04/09 16:17:23,
	Serialize complete at 2013/04/09 16:17:23
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-2022-JP
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/09/2013 01:14 PM, Yasuaki Ishimatsu wrote:
> Hi Tang,
> 
> The patch works well on my x86_64 box.
> I confirmed that hotpluggable node is allocated as Movable Zone.
> So feel free to add:
> 
> Tested by: Yasuaki Ishimatsu<isimatu.yasuaki@jp.fujitsu.com>
> 
> Nitpick below.

Thanks for testing. Will fix the whitespace error and resend the
patch-set soon. :)

