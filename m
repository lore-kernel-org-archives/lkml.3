Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752510AbaFJN4l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 09:56:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27405 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751664AbaFJN4j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 09:56:39 -0400
Message-ID: <53970E81.1070608@redhat.com>
Date: Tue, 10 Jun 2014 15:56:17 +0200
From: Hans de Goede <hdegoede@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: "kefeng.wang" <kefeng.wang@linaro.org>, Tejun Heo <tj@kernel.org>
CC: Zhangfei Gao <zhangfei.gao@linaro.org>, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org, wangkefeng.wang@huawei.com,
        xuwei5@hisilicon.com
Subject: Re: [PATCH] ahci: disable ncq feature for hisilicon sata
References: <1398416351-30567-1-git-send-email-kefeng.wang@linaro.org> <20140514170757.GD15690@htj.dyndns.org> <5396D529.308@linaro.org> <5396D8C9.6020607@linaro.org>
In-Reply-To: <5396D8C9.6020607@linaro.org>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kefeng,

On 06/10/2014 12:07 PM, kefeng.wang wrote:
> Hi Tejun,
> 
> I have a question, the hip04 and hix5hd2 soc use the old version of IP, but they
> also have a new version of IP which support FBS and NCQ, and now the new one is
> used by a new soc. How can I distinguish them, use "hisilicon,hisi-ahci-vX" or just
> add "generic-ahci" string for the IP which is conformant with spec and has
> no special customization and issue? Any advices, thanks.

Please use "hisilicon,hisi-ahci-vX", this way it will be easier to add any
special behavior in case this turns out to be necessary later.

Regards,

Hans
