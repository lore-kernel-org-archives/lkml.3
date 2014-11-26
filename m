Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753353AbaKZPOM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 10:14:12 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51610 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750845AbaKZPOL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 10:14:11 -0500
Date: Wed, 26 Nov 2014 10:09:08 -0500
From: Mike Snitzer <snitzer@redhat.com>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: device-mapper development <dm-devel@redhat.com>,
        linux-kernel@vger.kernel.org, Alasdair Kergon <agk@redhat.com>
Subject: Re: dm-bufio: fix memleak when using a dm_buffer's inline bio
Message-ID: <20141126150908.GB30136@redhat.com>
References: <20141126014515.GE10050@birch.djwong.org>
 <20141126034103.GA26585@redhat.com>
 <20141126040008.GF10050@birch.djwong.org>
 <20141126142832.GB29855@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141126142832.GB29855@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 26 2014 at  9:28am -0500,
Mike Snitzer <snitzer@redhat.com> wrote:

> 
> But in the context of bufio's embedded bio, using .bi_private seems
> fine.  Just needs a comment.  I'll fixup and get your patch staged (and
> will CC stable).

Staged for 3.19, see:
https://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=dm-for-3.19&id=c370192f925cf34280c7f6257e86dd79f79529d6
