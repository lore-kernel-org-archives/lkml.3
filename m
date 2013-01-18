Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751015Ab3ARIJI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 03:09:08 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:8004 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750750Ab3ARIJG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 03:09:06 -0500
X-IronPort-AV: E=Sophos;i="4.84,490,1355068800"; 
   d="scan'208";a="6611250"
Message-ID: <50F902F6.5010605@cn.fujitsu.com>
Date: Fri, 18 Jan 2013 16:08:22 +0800
From: Tang Chen <tangchen@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
CC: "H. Peter Anvin" <hpa@zytor.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, tony.luck@intel.com,
        akpm@linux-foundation.org, jiang.liu@huawei.com, wujianguo@huawei.com,
        wency@cn.fujitsu.com, laijs@cn.fujitsu.com, linfeng@cn.fujitsu.com,
        yinghai@kernel.org, rob@landley.net, minchan.kim@gmail.com,
        mgorman@suse.de, rientjes@google.com, guz.fnst@cn.fujitsu.com,
        rusty@rustcorp.com.au, lliubbo@gmail.com, jaegeuk.hanse@gmail.com,
        glommer@parallels.com, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH v5 0/5] Add movablecore_map boot option
References: <1358154925-21537-1-git-send-email-tangchen@cn.fujitsu.com> <50F440F5.3030006@zytor.com> <20130114143456.3962f3bd.akpm@linux-foundation.org> <3908561D78D1C84285E8C5FCA982C28F1C97C2DA@ORSMSX108.amr.corp.intel.com> <20130114144601.1c40dc7e.akpm@linux-foundation.org> <50F647E8.509@jp.fujitsu.com> <20130116132953.6159b673.akpm@linux-foundation.org> <50F72F17.9030805@zytor.com> <50F78750.8070403@jp.fujitsu.com> <50F79422.6090405@zytor.com> <3908561D78D1C84285E8C5FCA982C28F1C986D98@ORSMSX108.amr.corp.intel.com> <50F85ED5.3010003@jp.fujitsu.com> <50F8E63F.5040401@jp.fujitsu.com> <818a2b0a-f471-413f-9231-6167eb2d9607@email.android.com> <50F8FBE9.6040501@jp.fujitsu.com>
In-Reply-To: <50F8FBE9.6040501@jp.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/01/18 16:08:16,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/01/18 16:08:17,
	Serialize complete at 2013/01/18 16:08:17
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/18/2013 03:38 PM, Yasuaki Ishimatsu wrote:
> 2013/01/18 15:25, H. Peter Anvin wrote:
>> We already do DMI parsing in the kernel...
>
> Thank you for giving the infomation.
>
> Is your mention /sys/firmware/dmi/entries?
>
> If so, my box does not have memory information.
> My box has only type 0, 1, 2, 3, 4, 7, 8, 9, 38, 127 in DMI.
> At least, my box cannot use the information...
>
> If users use the boot parameter for investigating firmware bugs
> or debugging, users cannot use DMI information on like my box.

And seeing from Documentation/ABI/testing/sysfs-firmware-dmi,

	The kernel itself does not rely on the majority of the
	information in these tables being correct.  It equally
	cannot ensure that the data as exported to userland is
	without error either.

So when users are doing debug, they should not rely on this info.

