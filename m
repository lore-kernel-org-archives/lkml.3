Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754162Ab3ILLLe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 07:11:34 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:44059 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752943Ab3ILLLc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 07:11:32 -0400
Date: Thu, 12 Sep 2013 14:07:53 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: KY Srinivasan <kys@microsoft.com>
Cc: Wei Yongjun <weiyj.lk@gmail.com>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        "yongjun_wei@trendmicro.com.cn" <yongjun_wei@trendmicro.com.cn>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Drivers: hv: vmbus: fix error return code in
 vmbus_connect()
Message-ID: <20130912110752.GI25896@mwanda>
References: <CAPgLHd-5dt70Tn+3SXXu9QudpwpHaO1FNf-LZWQmDq413KLbQg@mail.gmail.com>
 <7463564f181640d2ad9658ce0ef7a7b5@SN2PR03MB061.namprd03.prod.outlook.com>
 <CAPgLHd_7MKG75y0NiXFVV-w8dtRWPdT8CtrMWyN_a1LM0MD9Lw@mail.gmail.com>
 <3e6ec2c583e14f17af1a5d2bd6aaab82@SN2PR03MB061.namprd03.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3e6ec2c583e14f17af1a5d2bd6aaab82@SN2PR03MB061.namprd03.prod.outlook.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 12, 2013 at 12:36:46AM +0000, KY Srinivasan wrote:
> When you try a given version, vmbus_negotiate_version() returns an error code
> if the host does not support that version. Hence, in this code you will not be able to
> run on anything prior to ws2012. I have already sent in a patch to fix that - if we timeout
> only then we jump to cleanup. In any event, if we tried all versions and none was acceptable
> to the host, we would return the value from vmbus_negotiate_version().
> 

First of all Wei's patch fixes an obvious bug.  Read the code.

If you already fixed it then what's the URL or the subject of your
email so we can look for it in our inbox.  Give us a clue here.

regards,
dan carpenter

