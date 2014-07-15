Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757630AbaGODzO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 23:55:14 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:37744 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757580AbaGODzB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 23:55:01 -0400
Content-Type: text/plain; charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 7.2 \(1874\))
Subject: Re: [PATCH v2] drivers: staging: lustre: Use 'force_die' instead of 'die' to avoid compiling issue
From: Chen Gang <gang.chen.5i5j@gmail.com>
In-Reply-To: <20140715014000.GA7849@kroah.com>
Date: Tue, 15 Jul 2014 11:59:03 +0800
Cc: devel@driverdev.osuosl.org, oleg.drokin@intel.com, paf@cray.com,
        andreas.dilger@intel.com, Andriy_Skulysh@xyratex.com,
        bergwolf@gmail.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        denis.pithon@gmail.com
Content-Transfer-Encoding: 8BIT
Message-Id: <AB2608A9-6F91-4D48-B57C-002B6A5D58E8@gmail.com>
References: <53C3C611.3020804@gmail.com> <53C3C73F.3080906@gmail.com> <20140715014000.GA7849@kroah.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
X-Mailer: Apple Mail (2.1874)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


在 2014年7月15日，上午9:40，Greg Kroah-Hartman <gregkh@linuxfoundation.org> 写道：

> On Mon, Jul 14, 2014 at 08:04:15PM +0800, Chen Gang wrote:
>> 
>> For drivers/staging/lustre/lustre/include/lustre_sec.h:391:
>> 
>> - staging tree: use '\t   ' between 'die' and '('.
>> 
>> - linux-next tree: use '   ' between 'die' and '('.
>> 
>> So the patch made under linux-next tree, can not apply to staging-next
>> or staging tree.
> 
> It seems to work just fine here, I don't see a problem...
> 


Yeah, the latest linux-next tree also uses ‘\t   “,  but the previous one not. :-)

Thanks.
—
Chen Gang
Open, share, and attitude like air, water, and life which God blessed