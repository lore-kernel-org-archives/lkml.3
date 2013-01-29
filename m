Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753405Ab3A2Sm5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 13:42:57 -0500
Received: from mx1.redhat.com ([209.132.183.28]:3495 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751647Ab3A2Smz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 13:42:55 -0500
From: Jeff Moyer <jmoyer@redhat.com>
To: Dave Kleikamp <dave.kleikamp@oracle.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Zach Brown <zab@zabbo.net>,
        "Maxim V. Patlasov" <mpatlasov@parallels.com>
Subject: Re: [PATCH V6 00/30] loop: Issue O_DIRECT aio using bio_vec
References: <1359476623-10544-1-git-send-email-dave.kleikamp@oracle.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Tue, 29 Jan 2013 13:42:43 -0500
In-Reply-To: <1359476623-10544-1-git-send-email-dave.kleikamp@oracle.com>
	(Dave Kleikamp's message of "Tue, 29 Jan 2013 10:23:13 -0600")
Message-ID: <x49obg7omos.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Kleikamp <dave.kleikamp@oracle.com> writes:

> Al,
> I'd like to push this patchset to linux-next. Would you like to pull it
> into your vfs tree, would you rather I submitted it separately, or do
> you have any issues with it before including it?

I'm still chasing one regression in this patchset.  If you use the ext4
driver for ext2 file systems, and you run the libaio test harness, then
you will be able to successfully write beyond the maximum file size in a
file (see test case 8).

Cheers,
Jeff
