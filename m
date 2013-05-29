Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759412Ab3E2ChL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 22:37:11 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:7765 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759366Ab3E2ChH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 22:37:07 -0400
X-Authority-Analysis: v=2.0 cv=DKcNElxb c=1 sm=0 a=ofFxtc/jepklO3aWSWiKGA==:17 a=99CFIlhQ8dUA:10 a=XqBCkJwx3yUA:10 a=TKDT-wfbsqsA:10 a=vQlp3vXYDpMA:10 a=8nJEP1OIZ-IA:10 a=2KX_Yc5PAAAA:8 a=GZI07OrTq7MA:10 a=i0EeH86SAAAA:8 a=JVblGoGcy55sHo_d2lEA:9 a=wPNLvfGTeEIA:10 a=hPjdaMEvmhQA:10 a=0IWVfpya8SkA:10 a=ofFxtc/jepklO3aWSWiKGA==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 70.112.99.80
Message-ID: <51A569CE.6010100@tabi.org>
Date: Tue, 28 May 2013 21:37:02 -0500
From: Timur Tabi <timur@tabi.org>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:20.0) Gecko/20100101 Firefox/20.0 SeaMonkey/2.17.1
MIME-Version: 1.0
To: Libo Chen <clbchenlibo.chen@huawei.com>,
        Greg KH <gregkh@linuxfoundation.org>
CC: jslaby@suse.cz, Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, linux-serial@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Li Zefan <lizefan@huawei.com>
Subject: Re: [PATCH] driver: tty: add missing unregister in err case
References: <51A568EC.2070103@huawei.com>
In-Reply-To: <51A568EC.2070103@huawei.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Libo Chen wrote:
> when platform_driver_register broken, we should unregister ucc_uart_driver
>
> Signed-off-by: Libo chen<libo.chen@huawei.com>

Acked-by: Timur Tabi <timur@tabi.org>

Thanks for catching this.

-- 
Timur Tabi
