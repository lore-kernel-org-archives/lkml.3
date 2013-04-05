Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161685Ab3DEGfE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 02:35:04 -0400
Received: from mail-wg0-f41.google.com ([74.125.82.41]:36705 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161327Ab3DEGfB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 02:35:01 -0400
Date: Fri, 5 Apr 2013 08:34:56 +0200
From: Stefan Hajnoczi <stefanha@gmail.com>
To: "Zhanghaoyu (A)" <haoyu.zhang@huawei.com>
Cc: kvm list <kvm@vger.kernel.org>, qemu-devel <qemu-devel@nongnu.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        "Huangweidong (C)" <weidong.huang@huawei.com>,
        Zanghongyong <zanghongyong@huawei.com>,
        Luonengjun <luonengjun@huawei.com>,
        Zhanghuanzhong <zhanghuanzhong@huawei.com>
Subject: Re: [Qemu-devel] qemu crashed when starting vm(kvm) with vnc connect
Message-ID: <20130405063456.GA27569@stefanha-thinkpad.redhat.com>
References: <D3E216785288A145B7BC975F83A2ED103FE154C1@szxeml556-mbx.china.huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <D3E216785288A145B7BC975F83A2ED103FE154C1@szxeml556-mbx.china.huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 02, 2013 at 09:02:02AM +0000, Zhanghaoyu (A) wrote:
> I start a kvm VM with vnc(using the zrle protocol) connect, sometimes qemu program crashed during starting period, received signal SIGABRT.
> Trying about 20 times, this crash may be reproduced.
> I guess the cause memory corruption or double free.

Which version of QEMU are you running?

Please try qemu.git/master.

Stefan
