Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759684AbaGXQiW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 12:38:22 -0400
Received: from mail-oi0-f51.google.com ([209.85.218.51]:61670 "EHLO
	mail-oi0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759448AbaGXQiT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 12:38:19 -0400
Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH] thermal: of: look for sensor driver parent node if device node missing
From: Eduardo Valentin <eduardo.valentin@gmail.com>
X-Mailer: iPhone Mail (11B554a)
In-Reply-To: <744357E9AAD1214791ACBA4B0B90926301396F53@SHSMSX101.ccr.corp.intel.com>
Date: Thu, 24 Jul 2014 12:38:15 -0400
Cc: Laxman Dewangan <ldewangan@nvidia.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <4324757E-1D43-42E9-BC7C-A633A29E7782@gmail.com>
References: <1405336354-31310-1-git-send-email-ldewangan@nvidia.com> <53D0D694.9040101@nvidia.com> <744357E9AAD1214791ACBA4B0B90926301396F53@SHSMSX101.ccr.corp.intel.com>
To: "Zhang, Rui" <rui.zhang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Perhaps you may have sent this email to the wrong Eduardo as I do not recognize the topic you are discussing.

Regards,

Sent from my iPhone

> On Jul 24, 2014, at 11:15 AM, "Zhang, Rui" <rui.zhang@intel.com> wrote:
> 
> Hi, Laxman,
> 
> As Eduardo is the of thermal author and maintainer, I will take your patch only if you can get ACK from Eduardo.
> 
> Eduardo,
> Do you have any comments on this?
> 
> Thanks,
> rui
> 
>> -----Original Message-----
>> From: Laxman Dewangan [mailto:ldewangan@nvidia.com]
>> Sent: Thursday, July 24, 2014 5:49 PM
>> To: Zhang, Rui; eduardo.valentin@ti.com
>> Cc: linux-pm@vger.kernel.org; linux-kernel@vger.kernel.org
>> Subject: Re: [PATCH] thermal: of: look for sensor driver parent node if
>> device node missing
>> Importance: High
>> 
>>> On Monday 14 July 2014 04:42 PM, Laxman Dewangan wrote:
>>> There are some mfd devices which supports junction thermal interrupt
>>> like ams,AS3722. The DT binding of these devices are defined as the
>>> flat and drivers for sub module of such devices are registered as the
>>> mfd_add_devices. In this method, the sub devices registered as
>>> platform driver and these do not have the of_node pointer on their
>>> device structure. In this case, use the parent of_node pointer to get
>>> the required of_node pointer.
>> Any comment please?
