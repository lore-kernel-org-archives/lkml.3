Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753022AbaFYGMK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 02:12:10 -0400
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:41974 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752686AbaFYGMI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 02:12:08 -0400
Date: Wed, 25 Jun 2014 14:11:56 +0800
From: Wei Yang <weiyang@linux.vnet.ibm.com>
To: Or Gerlitz <ogerlitz@mellanox.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Wei Yang <weiyang@linux.vnet.ibm.com>,
        "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>,
        Amir Vadai <amirv@mellanox.com>,
        Jack Morgenstein <jackm@dev.mellanox.co.il>,
        Or Gerlitz <or.gerlitz@gmail.com>
Subject: Re: [PATCH 3.10 26/52] net/mlx4_core: Preserve pci_dev_data after
 __mlx4_remove_one()
Message-ID: <20140625061156.GA15078@richard>
Reply-To: Wei Yang <weiyang@linux.vnet.ibm.com>
References: <20140624154713.428945460@linuxfoundation.org>
 <20140624154715.067497332@linuxfoundation.org>
 <53AA65F2.8060405@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53AA65F2.8060405@mellanox.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14062506-1396-0000-0000-00000519E2E5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 25, 2014 at 09:02:26AM +0300, Or Gerlitz wrote:
>On 24/06/2014 18:50, Greg Kroah-Hartman wrote:
>>3.10-stable review patch.  If anyone has any objections, please let me know.
>>
>>------------------
>>
>>From: Wei Yang <weiyang@linux.vnet.ibm.com>
>>
>>[ Upstream commit befdf8978accecac2e0739e6b5075afc62db37fe ]
>
>Hi Wei, Dave,
>
>In the same manner you acted for 3.14.y -- for this commit to go into
>3.10.y it must be accompanied by commit
>da1de8dfff09d33d4a5345762c21b487028e25f5  "net/mlx4_core: Keep only
>one driver entry release mlx4_priv" which fixes a bug introduced by
>the former, agree?
>

Agree. The latest fix is important.

Do I need to rebase it on these versions and send out?

>Or.

-- 
Richard Yang
Help you, Help me

