Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752606Ab3GIBI2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 21:08:28 -0400
Received: from mail.linux-iscsi.org ([67.23.28.174]:56140 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751279Ab3GIBIY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 21:08:24 -0400
Message-ID: <1373332406.7397.161.camel@haakon3.risingtidesystems.com>
Subject: Re: linux-next: manual merge of the vhost tree with the
 target-updates tree
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Asias He <asias@redhat.com>,
        target-devel <target-devel@vger.kernel.org>
Date: Mon, 08 Jul 2013 18:13:26 -0700
In-Reply-To: <20130708134721.8ac2d67125b60c745d46006f@canb.auug.org.au>
References: <20130708134721.8ac2d67125b60c745d46006f@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-07-08 at 13:47 +1000, Stephen Rothwell wrote:
> Hi Michael,
> 
> Today's linux-next merge of the vhost tree got a conflict in
> drivers/vhost/scsi.c between commit 084ed45b3846 ("vhost/scsi: Convert to
> se_cmd->cmd_kref TARGET_SCF_ACK_KREF usage") from the target-updates tree
> and commit 3c63f66a0dcd ("vhost-scsi: Rename struct tcm_vhost_cmd *tv_cmd
> to *cmd") from the vhost tree.
> 
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).
> 

Hi Stephen,

Can you briefly refresh my memory how the process of 'carrying the fix'
in linux-next should work..?

So once I send a -rc1 PULL request to Linus over the next days, and MST
sends one shortly there-after and hits a conflict, you'll include this
patch in a separate next-fixes branch for Linus to PULL..?

--nab

