Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753841Ab3EUK17 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 06:27:59 -0400
Received: from mga09.intel.com ([134.134.136.24]:21289 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753167Ab3EUK16 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 06:27:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,713,1363158000"; 
   d="scan'208";a="340722912"
Message-ID: <519B4C0D.3040602@linux.intel.com>
Date: Tue, 21 May 2013 13:27:25 +0300
From: Eliezer Tamir <eliezer.tamir@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Or Gerlitz <or.gerlitz@gmail.com>
CC: David Miller <davem@davemloft.net>, eilong@broadcom.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        jesse.brandeburg@intel.com, donald.c.skidmore@intel.com,
        e1000-devel@lists.sourceforge.net, willemb@google.com,
        andi@firstfloor.org, hpa@zytor.com, eliezer@tamir.org.il
Subject: Re: [PATCH v3 net-next 3/4] ixgbe: Add support for ndo_ll_poll
References: <1369120003.25971.2.camel@lb-tlvb-eilong.il.broadcom.com> <20130521.001444.1361294042663568537.davem@davemloft.net> <CAJZOPZJTA9A8T4R8MtRCeqcYj3XJWFCXF+ojmEqza5TMj-6G+w@mail.gmail.com> <20130521.013912.96249995742935192.davem@davemloft.net> <CAJZOPZJD5QpkmkJF9qpWV3Q28aioLw5CuT5X4URxDC4eSby3nQ@mail.gmail.com>
In-Reply-To: <CAJZOPZJD5QpkmkJF9qpWV3Q28aioLw5CuT5X4URxDC4eSby3nQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21/05/2013 11:43, Or Gerlitz wrote:
> On Tue, May 21, 2013 at 11:39 AM, David Miller <davem@davemloft.net> wrote:
>
>> It's one of those "implementation details", I hate it too.
>
> Maybe if we bake it on this list little further we can see how to get
> away from that, or what's the most non ugly way for that?

I'm all for proper review and fixing any issues before forcing 
"ugliness" and "black magic" on unsuspecting users.

Having said that, you failed to mention that your company sells 
userspace stack replacements.

Informal testing I did convinces me that for a given HW, the latencies 
you get with this patchset and with userspace busy-polling are about the 
same. (This is my personal opinion, I'm not authorized to talk on behalf 
of my company or anyone else.)

Why don't you try it out and tell us what you find.

