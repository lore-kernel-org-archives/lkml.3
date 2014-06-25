Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753110AbaFYGX0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 02:23:26 -0400
Received: from eu1sys200aog111.obsmtp.com ([207.126.144.131]:52837 "EHLO
	eu1sys200aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752391AbaFYGXY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 02:23:24 -0400
X-Greylist: delayed 1248 seconds by postgrey-1.27 at vger.kernel.org; Wed, 25 Jun 2014 02:23:18 EDT
Message-ID: <53AA6A94.7000104@mellanox.com>
Date: Wed, 25 Jun 2014 09:22:12 +0300
From: Or Gerlitz <ogerlitz@mellanox.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Wei Yang <weiyang@linux.vnet.ibm.com>,
        "David S. Miller" <davem@davemloft.net>
CC: <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, Amir Vadai <amirv@mellanox.com>,
        Jack Morgenstein <jackm@dev.mellanox.co.il>,
        Or Gerlitz <or.gerlitz@gmail.com>
Subject: Re: [PATCH 3.10 26/52] net/mlx4_core: Preserve pci_dev_data after
 __mlx4_remove_one()
References: <20140624154713.428945460@linuxfoundation.org> <20140624154715.067497332@linuxfoundation.org> <53AA6600.6040701@mellanox.com>
In-Reply-To: <53AA6600.6040701@mellanox.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.222.66.109]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25/06/2014 09:02, Or Gerlitz wrote:
> On 24/06/2014 18:50, Greg Kroah-Hartman wrote:
>> 3.10-stable review patch.  If anyone has any objections, please let 
>> me know.
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
> da1de8dfff09d33d4a5345762c21b487028e25f5  "net/mlx4_core: Keep only 
> one driver entry release mlx4_priv" which fixes a bug introduced by 
> the former, agree?
>
>
>
NAK, you're right... we only need the 2nd fix for kernels >= 3.14 which 
contain commit 367d56f "net/mlx4: Support shutdown() interface", before 
that -- it's irrelevant, sorry for the spam.


