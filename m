Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754341AbaAVKJW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 05:09:22 -0500
Received: from mail-we0-f177.google.com ([74.125.82.177]:59834 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751516AbaAVKJV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 05:09:21 -0500
Message-ID: <52DF98CA.3000300@dev.mellanox.co.il>
Date: Wed, 22 Jan 2014 12:09:14 +0200
From: Sagi Grimberg <sagig@dev.mellanox.co.il>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: "Martin K. Petersen" <martin.petersen@oracle.com>
CC: "Nicholas A. Bellinger" <nab@daterainc.com>,
        target-devel <target-devel@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        Sagi Grimberg <sagig@mellanox.com>, Or Gerlitz <ogerlitz@mellanox.com>,
        Roland Dreier <roland@kernel.org>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: Re: [PATCH-v2 11/17] target/iblock: Add blk_integrity + BIP passthrough
 support
References: <1390099480-29013-1-git-send-email-nab@daterainc.com>	<1390099480-29013-12-git-send-email-nab@daterainc.com>	<52DBC32C.4060505@dev.mellanox.co.il> <yq1fvogbx5a.fsf@sermon.lab.mkp.net>
In-Reply-To: <yq1fvogbx5a.fsf@sermon.lab.mkp.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/22/2014 3:52 AM, Martin K. Petersen wrote:
>>>>>> "Sagi" == Sagi Grimberg <sagig@dev.mellanox.co.il> writes:
> Sagi> Please remind me why we ignore IP-CSUM guard type again?  MKP,
> Sagi> will this be irrelevant for the initiator as well? if so, I don't
> Sagi> see a reason to expose this in RDMA verbs.
>
> I don't see much use for IP checksum for the target. You are required by
> SBC to use T10 CRC on the wire so there is no point in converting to IP
> checksum in the backend.
>
> My impending patches will allow you to pass through PI with T10 CRC to a
> device with an IP checksum block integrity profile (i.e. the choice of
> checksum is a per-bio bip flag instead of an HBA-enforced global).
>

OK, so IP checksum support still makes sense.

Thanks!

Sagi.
