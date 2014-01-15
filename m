Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752993AbaAOSDn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 13:03:43 -0500
Received: from eu1sys200aog111.obsmtp.com ([207.126.144.131]:43396 "EHLO
	eu1sys200aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752638AbaAOSDj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 13:03:39 -0500
Message-ID: <52D6CD70.20706@mellanox.com>
Date: Wed, 15 Jan 2014 20:03:28 +0200
From: sagi grimberg <sagig@mellanox.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: "Nicholas A. Bellinger" <nab@daterainc.com>,
        target-devel <target-devel@vger.kernel.org>
CC: linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        Or Gerlitz <ogerlitz@mellanox.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: Re: [PATCH 00/14] target: Initial support for DIF Type1+Type3 emulation
References: <1389212157-14540-1-git-send-email-nab@daterainc.com>
In-Reply-To: <1389212157-14540-1-git-send-email-nab@daterainc.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.0.13.1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/8/2014 10:36 PM, Nicholas A. Bellinger wrote:
> From: Nicholas Bellinger <nab@linux-iscsi.org>
>
> Hi MKP & SCSI folks,
>
> This series contains initial support for target mode DIF Type1+Type3
> emulation within target core, RAMDISK_MCP device backend, and tcm_loop
> fabric driver.
>
> DIF emulation is enabled via a new 'pi_prot_type' device attribute
> within configfs, which is set after initial device configuration and
> before target fabric LUN export occurs.
>
> The DIF read/write verify emulation has been made generic enough so
> it can be used by other backend drivers (eg: FILEIO), as well as
> DIF v2 in the near future.  Also note that the majority of the logic
> has been groked from existing scsi_debug.c code.
>
> The current plan is to enable basic support for emulated backends with
> tcm_loop for v3.14 code, and then move onto IBLOCK backend support
> (that requires BLOCK layer changes)

Hey Nic,
Can you please elaborate on what BLOCK layer changes are required?
I didn't spot any misses from Looking at 
Documentation/block/data-integrity.txt.

Am I missing something?

Sagi.
