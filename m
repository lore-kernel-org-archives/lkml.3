Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754380AbaFYGN2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 02:13:28 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:58136 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753335AbaFYGN0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 02:13:26 -0400
Date: Tue, 24 Jun 2014 23:13:23 -0700 (PDT)
Message-Id: <20140624.231323.1246980184268143860.davem@davemloft.net>
To: ogerlitz@mellanox.com
Cc: gregkh@linuxfoundation.org, weiyang@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        bhelgaas@google.com, amirv@mellanox.com, jackm@dev.mellanox.co.il,
        or.gerlitz@gmail.com
Subject: Re: [PATCH 3.10 26/52] net/mlx4_core: Preserve pci_dev_data after
 __mlx4_remove_one()
From: David Miller <davem@davemloft.net>
In-Reply-To: <53AA65F2.8060405@mellanox.com>
References: <20140624154713.428945460@linuxfoundation.org>
	<20140624154715.067497332@linuxfoundation.org>
	<53AA65F2.8060405@mellanox.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 24 Jun 2014 23:13:26 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Or Gerlitz <ogerlitz@mellanox.com>
Date: Wed, 25 Jun 2014 09:02:26 +0300

> On 24/06/2014 18:50, Greg Kroah-Hartman wrote:
>> 3.10-stable review patch.  If anyone has any objections, please let me
>> know.
>>
>> ------------------
>>
>> From: Wei Yang <weiyang@linux.vnet.ibm.com>
>>
>> [ Upstream commit befdf8978accecac2e0739e6b5075afc62db37fe ]
> 
> Hi Wei, Dave,
> 
> In the same manner you acted for 3.14.y -- for this commit to go into
> 3.10.y it must be accompanied by commit
> da1de8dfff09d33d4a5345762c21b487028e25f5 "net/mlx4_core: Keep only one
> driver entry release mlx4_priv" which fixes a bug introduced by the
> former, agree?

That's impossible, there is no shutdown method defined in the 3.10.x
version of the mlx4 driver.

That's why I didn't include that change.
