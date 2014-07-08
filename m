Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752962AbaGHGOm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 02:14:42 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:40601 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752253AbaGHGOl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 02:14:41 -0400
Message-ID: <53BB8C3F.306@ti.com>
Date: Tue, 8 Jul 2014 11:44:23 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/8] phy: core: Fix error path in phy_create()
References: <1404715705-5041-1-git-send-email-kishon@ti.com> <1404715705-5041-6-git-send-email-kishon@ti.com> <20140708014506.GC13844@kroah.com>
In-Reply-To: <20140708014506.GC13844@kroah.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tuesday 08 July 2014 07:15 AM, Greg KH wrote:
> On Mon, Jul 07, 2014 at 12:18:22PM +0530, Kishon Vijay Abraham I wrote:
>> From: Roger Quadros <rogerq@ti.com>
>>
>> Prevent resources from being freed twice in case device_add() call
>> fails within phy_create(). Also use ida_simple_remove() instead of
>> ida_remove() as we had used ida_simple_get() to allocate the ida.
>>
>> Signed-off-by: Roger Quadros <rogerq@ti.com>
>> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
>> ---
>>  drivers/phy/phy-core.c |    7 ++++---
>>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> Is this a problem in older kernels as well?

yeah. Will send it for stable kernel.

Thanks
Kishon
