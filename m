Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752604Ab3KKVUo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 16:20:44 -0500
Received: from mail.linux-iscsi.org ([67.23.28.174]:60796 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751109Ab3KKVUi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 16:20:38 -0500
Message-ID: <1384204833.12281.9.camel@haakon3.risingtidesystems.com>
Subject: Re: [PATCH 0/5] percpu_ida: Various tweaks
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Alexander Gordeev <agordeev@redhat.com>,
        Kent Overstreet <kmo@daterainc.com>, Oleg Nesterov <oleg@redhat.com>,
        linux-kernel@vger.kernel.org
Date: Mon, 11 Nov 2013 13:20:33 -0800
In-Reply-To: <20131111193947.GD25231@kernel.dk>
References: <20131028100440.GA5744@dhcp-26-207.brq.redhat.com>
	 <1382995746.19256.756.camel@haakon3.risingtidesystems.com>
	 <20131111193433.GA9679@dhcp-26-207.brq.redhat.com>
	 <20131111193947.GD25231@kernel.dk>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-11-11 at 12:39 -0700, Jens Axboe wrote:
> On Mon, Nov 11 2013, Alexander Gordeev wrote:
> > On Mon, Oct 28, 2013 at 02:29:06PM -0700, Nicholas A. Bellinger wrote:
> > > I'll wait for Kent's feedback on these, and end-up dropping the
> > > blk-mq-tag part from Patch #5 for the moment..
> > 
> > Hi Nicholas,
> > 
> > I am bit uncertain regarding the process concerning your and Jens trees.
> > Are you planning to pull Shaohua's percpu_ida conversion?
> 
> The submitted blk-mq bits have the conversion, the old tagging is no
> longer active/maintained. So any work on this going forward will have to
> be based on the percpu ida conversion.
> 

What Jen's said..

I'll be updating the scsi-mq working branch soon after blk-mq is pulled
into v3.13-rc1 code.

--nab

