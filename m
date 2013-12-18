Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752795Ab3LRX6t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 18:58:49 -0500
Received: from mail.linux-iscsi.org ([67.23.28.174]:35095 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751258Ab3LRX6r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 18:58:47 -0500
Message-ID: <1387411170.5567.3.camel@haakon3.risingtidesystems.com>
Subject: Re: linux-next: build warning after merge of the target-updates tree
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Hannes Reinecke <hare@suse.de>,
        target-devel <target-devel@vger.kernel.org>
Date: Wed, 18 Dec 2013 15:59:30 -0800
In-Reply-To: <20131218173930.56f758971ca1939cbc3e67ec@canb.auug.org.au>
References: <20131218173930.56f758971ca1939cbc3e67ec@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On Wed, 2013-12-18 at 17:39 +1100, Stephen Rothwell wrote:
> Hi Nicholas,
> 
> After merging the target-updates tree, today's linux-next build (x86_64
> allmodconfig) produced this warning:
> 
> drivers/target/target_core_alua.c: In function 'core_alua_state_lba_dependent':
> drivers/target/target_core_alua.c:473:6: warning: suggest parentheses around operand of '!' or change '&' to '&&' or '!' to '~' [-Wparentheses]
>   if (!cmd->se_cmd_flags & SCF_SCSI_DATA_CDB)
>       ^
> 
> Introduced by commit 923aacab87ba ("target_core_alua: Referrals
> infrastructure").

Fixed for today's linux-next tree.

Thank you,

--nab

