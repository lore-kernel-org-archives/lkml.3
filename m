Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752805AbaFKIsB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 04:48:01 -0400
Received: from mail-ve0-f180.google.com ([209.85.128.180]:35216 "EHLO
	mail-ve0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750958AbaFKIr7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 04:47:59 -0400
MIME-Version: 1.0
In-Reply-To: <538EAD90.9000706@cn.fujitsu.com>
References: <alpine.LFD.2.11.1405191908450.1847@denkbrett>
	<20140519180851.GD2915@kvack.org>
	<alpine.LFD.2.11.1405200950480.1606@denkbrett>
	<alpine.LFD.2.11.1405201508450.1606@denkbrett>
	<CAOMFOmWfQ2naF+1BE0wSQXpBoyxV6MPm021hY77B4sDpZNZ-Dw@mail.gmail.com>
	<alpine.LFD.2.11.1405201945280.1631@denkbrett>
	<CAOMFOmUT-WGbV57qDafM-NJ+=s1OzX-2Q6G6hAh6EV8Vt9yBZw@mail.gmail.com>
	<alpine.LFD.2.11.1405210954110.1579@denkbrett>
	<alpine.LFD.2.11.1405211042350.1579@denkbrett>
	<CAOMFOmXXHBicH38onWgVAWhEXe2sE_RMiJXi=iMjJB15o7mOLQ@mail.gmail.com>
	<alpine.LFD.2.11.1405211643180.1579@denkbrett>
	<538EAD90.9000706@cn.fujitsu.com>
Date: Wed, 11 Jun 2014 16:47:58 +0800
Message-ID: <CACVXFVOT9+dyJBv3dRLyQ4Fk11i_P6tCqo0i196Wt1bXS_2Wqg@mail.gmail.com>
Subject: Re: hanging aio process
From: Ming Lei <tom.leiming@gmail.com>
To: Gu Zheng <guz.fnst@cn.fujitsu.com>
Cc: Sebastian Ott <sebott@linux.vnet.ibm.com>,
        Anatol Pomozov <anatol.pomozov@gmail.com>,
        Benjamin LaHaise <bcrl@kvack.org>, linux-aio@kvack.org,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 4, 2014 at 1:24 PM, Gu Zheng <guz.fnst@cn.fujitsu.com> wrote:
> Hi Guys,
> What's the status of this issue? Has it been fixed?

Yes, it is fixed by percpu_ref, and is merged to 3.15 already.

Thanks,
-- 
Ming Lei
