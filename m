Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753087Ab3GIGHi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 02:07:38 -0400
Received: from mail.linux-iscsi.org ([67.23.28.174]:41957 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752722Ab3GIGHg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 02:07:36 -0400
Message-ID: <1373350358.7397.169.camel@haakon3.risingtidesystems.com>
Subject: Re: linux-next: manual merge of the vhost tree with the
 target-updates tree
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Asias He <asias@redhat.com>,
        target-devel <target-devel@vger.kernel.org>
Date: Mon, 08 Jul 2013 23:12:38 -0700
In-Reply-To: <20130709132753.4ccecde4e20ac109ebeedc8e@canb.auug.org.au>
References: <20130708134721.8ac2d67125b60c745d46006f@canb.auug.org.au>
	 <1373332406.7397.161.camel@haakon3.risingtidesystems.com>
	 <20130709132753.4ccecde4e20ac109ebeedc8e@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-07-09 at 13:27 +1000, Stephen Rothwell wrote:
> Hi Nicholas,
> 
> On Mon, 08 Jul 2013 18:13:26 -0700 "Nicholas A. Bellinger" <nab@linux-iscsi.org> wrote:
> >
> > On Mon, 2013-07-08 at 13:47 +1000, Stephen Rothwell wrote:
> > > 
> > > Today's linux-next merge of the vhost tree got a conflict in
> > > drivers/vhost/scsi.c between commit 084ed45b3846 ("vhost/scsi: Convert to
> > > se_cmd->cmd_kref TARGET_SCF_ACK_KREF usage") from the target-updates tree
> > > and commit 3c63f66a0dcd ("vhost-scsi: Rename struct tcm_vhost_cmd *tv_cmd
> > > to *cmd") from the vhost tree.
> > > 
> > > I fixed it up (see below) and can carry the fix as necessary (no action
> > > is required).
> > > 
> > 
> > Can you briefly refresh my memory how the process of 'carrying the fix'
> > in linux-next should work..?
> 
> That means that (assuming my fix is correct), I will continue to apply
> that fix until your trees are merged into Linus' tree.  (git rerere is my
> friend :-))
> 
> > So once I send a -rc1 PULL request to Linus over the next days, and MST
> > sends one shortly there-after and hits a conflict, you'll include this
> > patch in a separate next-fixes branch for Linus to PULL..?
> 
> No, Linus will figure it out just as I did.  If you want to give him a
> hint, that 's fine.  The main intention of my "I fixed it up and can
> carry the fix as necessary (no action is required)" is to just get you
> guys to check that what I did was correct, and to dissuade you from
> merging/rebasing/rewriting your tree(s) to eliminate the conflict.
> 

Yes, of course.  I'll be sure to include a heads up in the PULL request.

Thanks again,

--nab

