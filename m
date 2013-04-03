Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760019Ab3DCHvm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 03:51:42 -0400
Received: from mail-la0-f47.google.com ([209.85.215.47]:48928 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758225Ab3DCHvk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 03:51:40 -0400
From: Dmitry Monakhov <dmonakhov@openvz.org>
To: CAI Qian <caiqian@redhat.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>, LKML <linux-kernel@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>, Steve Best <sbest@redhat.com>,
        linux-ext4@vger.kernel.org, Lukas Czerner <lczerner@redhat.com>,
        stable@vger.kernel.org
Subject: Re: bisected! (WAS Re: s390x: kernel BUG at fs/ext4/inode.c:1591!)
In-Reply-To: <1158933859.1177381.1364973284305.JavaMail.root@redhat.com>
References: <2133129347.8273339.1364549222854.JavaMail.root@redhat.com> <87ip46ss0o.fsf@openvz.org> <1211053180.322948.1364797847717.JavaMail.root@redhat.com> <87fvzaspr8.fsf@openvz.org> <874841142.414482.1364875584266.JavaMail.root@redhat.com> <874nfps133.fsf@openvz.org> <876098945.1097253.1364961617725.JavaMail.root@redhat.com> <1158933859.1177381.1364973284305.JavaMail.root@redhat.com>
User-Agent: Notmuch/0.6.1 (http://notmuchmail.org) Emacs/23.3.1 (x86_64-redhat-linux-gnu)
Date: Wed, 03 Apr 2013 11:51:34 +0400
Message-ID: <87obdwqcft.fsf@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Apr 2013 03:14:44 -0400 (EDT), CAI Qian <caiqian@redhat.com> wrote:
> 
> > > [Text Documents:disable-es_lookup_extent.patch]
> With this patch, I cannot reproduce it any more.
Ok that is second confirmation that bug caused by issue in es_cache,
This is not a fix though. So still try to investigate that.
> 
> CAI Qian
