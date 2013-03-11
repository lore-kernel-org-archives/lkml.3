Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753584Ab3CKPYW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 11:24:22 -0400
Received: from mx0.parallels.com ([199.115.104.20]:60110 "EHLO
	mx0.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751105Ab3CKPYT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 11:24:19 -0400
From: James Bottomley <jbottomley@parallels.com>
To: Steven Rostedt <rostedt@goodmis.org>
CC: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 12/13] scsi/tracing: include correct header file
Thread-Topic: [PATCH 12/13] scsi/tracing: include correct header file
Thread-Index: AQHOHigYv9CZ7BqHwUekH+0/Euc9UpihAGmAgAARmwA=
Date: Mon, 11 Mar 2013 15:24:16 +0000
Message-ID: <1363015456.2395.80.camel@dabdike.int.hansenpartnership.com>
References: <513D844D.7000301@huawei.com>
	 <1363011675.12608.14.camel@gandalf.local.home>
In-Reply-To: <1363011675.12608.14.camel@gandalf.local.home>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [46.65.52.191]
Content-Type: text/plain; charset=US-ASCII
Content-ID: <DD3ADD2C833753458F87097BDD05D969@sw.swsoft.com>
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-03-11 at 10:21 -0400, Steven Rostedt wrote:
> As you didn't include James in the header patch [0/13], he didn't see
> you say:
> 
> "Two patches changed compilation on scsi subsystem, it should go through
> to
> SCSI tree."
> 
> In the future, send them as a separate patch series. There's no
> dependencies on these patches with the rest of the series. They should
> have been sent directly to James, with me as the Cc.

Actually, if you want them applied, they need to go to the SCSI list
<linux-scsi@vger.kernel.org>.  It tracks all my pending patches.  Stuff
to me personally has a high probability of getting forgotten.

Thanks,

James

