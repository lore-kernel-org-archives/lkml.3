Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967067Ab3DRJZ0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 05:25:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9940 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966349Ab3DRJZU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 05:25:20 -0400
Message-ID: <516FBBF7.1080400@redhat.com>
Date: Thu, 18 Apr 2013 11:25:11 +0200
From: Gerd Hoffmann <kraxel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Stefan Hajnoczi <stefanha@gmail.com>
CC: "Zhanghaoyu (A)" <haoyu.zhang@huawei.com>,
        "Huangweidong (C)" <weidong.huang@huawei.com>,
        kvm list <kvm@vger.kernel.org>, Marcelo Tosatti <mtosatti@redhat.com>,
        Luonengjun <luonengjun@huawei.com>, qemu-devel <qemu-devel@nongnu.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Zanghongyong <zanghongyong@huawei.com>,
        Zhanghuanzhong <zhanghuanzhong@huawei.com>, corentin.chary@gmail.com
Subject: Re: [Qemu-devel] reply: reply: qemu crashed when starting vm(kvm)
 with vnc connect
References: <D3E216785288A145B7BC975F83A2ED103FE154C1@szxeml556-mbx.china.huawei.com> <20130405063456.GA27569@stefanha-thinkpad.redhat.com> <D3E216785288A145B7BC975F83A2ED103FE16528@szxeml556-mbx.china.huawei.com> <20130408105052.GC12076@stefanha-thinkpad.redhat.com> <D3E216785288A145B7BC975F83A2ED103FE16749@szxeml556-mbx.china.huawei.com> <20130411092958.GF8904@stefanha-thinkpad.redhat.com>
In-Reply-To: <20130411092958.GF8904@stefanha-thinkpad.redhat.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/11/13 11:29, Stefan Hajnoczi wrote:
> On Mon, Apr 08, 2013 at 12:27:06PM +0000, Zhanghaoyu (A) wrote:
>> On Sun, Apr 07, 2013 at 04:58:07AM +0000, Zhanghaoyu (A) wrote:
>>>>>> I start a kvm VM with vnc(using the zrle protocol) connect, sometimes qemu program crashed during starting period, received signal SIGABRT.
>>>>>> Trying about 20 times, this crash may be reproduced.
>>>>>> I guess the cause memory corruption or double free.
>>>>>
>>>>> Which version of QEMU are you running?
>>>>>
>>>>> Please try qemu.git/master.

Please try again with latest master, might be fixed meanwhile.

If it still happens pleas provide full qemu and vnc client command lines.

>> backtrace from core file is shown as below:
>>
>> Program received signal SIGABRT, Aborted.

>> #8  0x00007f32efd26d07 in vnc_disconnect_finish (vs=0x7f32f0c762d0)
>>     at ui/vnc.c:1050

Do you have a vnc client connected?  Do you close it?

Any errors reported by the vnc client (maybe it disconnects due to an
error in the data stream)?

cheers,
  Gerd


