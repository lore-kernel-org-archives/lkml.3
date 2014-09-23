Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756248AbaIWQGU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 12:06:20 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42214 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756160AbaIWQGH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 12:06:07 -0400
Message-ID: <54219A6C.7000407@suse.cz>
Date: Tue, 23 Sep 2014 18:06:04 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: sfr@canb.auug.org.au, rdunlap@infradead.org, netdev@vger.kernel.org,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org, linux-mips@linux-mips.org
Subject: Re: [PATCH 1/5] mips: Set CONFIG_NET=y in defconfigs
References: <54218AEF.5090200@suse.cz>	<1411487044-14071-1-git-send-email-mmarek@suse.cz> <20140923.120237.1788295912902036193.davem@davemloft.net>
In-Reply-To: <20140923.120237.1788295912902036193.davem@davemloft.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-09-23 18:02, David Miller wrote:
> From: Michal Marek <mmarek@suse.cz>
> Date: Tue, 23 Sep 2014 17:44:00 +0200
> 
>> Commit 5d6be6a5 ("scsi_netlink : Make SCSI_NETLINK dependent on NET
>> instead of selecting NET") removed what happened to be the only instance
>> of 'select NET'. Defconfigs that were relying on the select now lack
>> networking support.
>>
>> Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
>> Cc: linux-mips@linux-mips.org
>> Signed-off-by: Michal Marek <mmarek@suse.cz>
> 
> On the contrary, since NET was being selected for them indirectly
> previously, weren't they depending instead upon NET being enabled?
> 
> Likewise for SCSI_NETLINK, SCSI_FC_ATTRS, and whatever was triggering
> the select upon them?

They have SCSI_FC_ATTRS=y/m and were relying on the select statements
turning this into SCSI_NETLINK=y and CONFIG_NET=y.

Michal
