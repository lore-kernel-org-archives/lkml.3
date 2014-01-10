Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752467AbaAJFzp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 00:55:45 -0500
Received: from mail.linux-iscsi.org ([67.23.28.174]:48469 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750947AbaAJFzn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 00:55:43 -0500
Message-ID: <1389333445.5567.367.camel@haakon3.risingtidesystems.com>
Subject: Re: [PATCH 00/14] target: Initial support for DIF Type1+Type3
 emulation
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: "Nicholas A. Bellinger" <nab@daterainc.com>,
        target-devel <target-devel@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        Sagi Grimberg <sagig@mellanox.com>, Or Gerlitz <ogerlitz@mellanox.com>
Date: Thu, 09 Jan 2014 21:57:25 -0800
In-Reply-To: <yq1mwj4sii9.fsf@sermon.lab.mkp.net>
References: <1389212157-14540-1-git-send-email-nab@daterainc.com>
	 <yq1mwj4sii9.fsf@sermon.lab.mkp.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-01-09 at 21:00 -0500, Martin K. Petersen wrote:
> >>>>> "Nic" == Nicholas A Bellinger <nab@daterainc.com> writes:
> 
> Nic> This series contains initial support for target mode DIF
> Nic> Type1+Type3 emulation within target core, RAMDISK_MCP device
> Nic> backend, and tcm_loop fabric driver.
> 
> Super cool! Do you have a git tree so I can start tinkering with this?

Most certainly, it's been pushed to target-pending/auto-next.

> 
> I'll start reviewing the pieces tomorrow.

Excellent.

Thanks MKP!

--nab

