Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751430AbaALMSY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jan 2014 07:18:24 -0500
Received: from mail-ee0-f67.google.com ([74.125.83.67]:34974 "EHLO
	mail-ee0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751326AbaALMSS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jan 2014 07:18:18 -0500
Message-ID: <52D28807.2000004@dev.mellanox.co.il>
Date: Sun, 12 Jan 2014 14:18:15 +0200
From: Sagi Grimberg <sagig@dev.mellanox.co.il>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: "Martin K. Petersen" <martin.petersen@oracle.com>,
        "Nicholas A. Bellinger" <nab@daterainc.com>
CC: target-devel <target-devel@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        Sagi Grimberg <sagig@mellanox.com>, Or Gerlitz <ogerlitz@mellanox.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: Re: [PATCH 09/14] target/configfs: Expose protection device attributes
References: <1389212157-14540-1-git-send-email-nab@daterainc.com>	<1389212157-14540-10-git-send-email-nab@daterainc.com> <yq161prr1p8.fsf@sermon.lab.mkp.net>
In-Reply-To: <yq161prr1p8.fsf@sermon.lab.mkp.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

<SNIP>

> nab> This patch adds support for exposing DIF protection device
> nab> attributes via configfs.  This includes:
>
> nab>    pi_prot_type: Protection Type (0, 1, 3 currently support)
> nab>    pi_prot_version: Protection Version (DIF v1 currently supported)
>
> What's DIF v2?
>
> nab>    pi_guard_type: Guard Type (1=DIF CRC, 2=IP CRC)
>
> The IP checksum is only supported by DIX between OS and initiator, not
> by the target. I guess we could signal to the initiator via a
> vendor-private VPD that IP checksum is supported directly. But now what
> we have hardware-accelerated T10 CRC I don't think it's a big deal.

shouldn't it stick around if it is not deprecated yet, the transport is 
required to support ip-csum->CRC conversion anyhow.

> (scsi_debug supports IP checksum because it's both initiator and
> target).
>


