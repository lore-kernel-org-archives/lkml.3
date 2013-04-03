Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762962Ab3DCHOv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 03:14:51 -0400
Received: from mx3-phx2.redhat.com ([209.132.183.24]:38530 "EHLO
	mx3-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762945Ab3DCHOt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 03:14:49 -0400
Date: Wed, 3 Apr 2013 03:14:44 -0400 (EDT)
From: CAI Qian <caiqian@redhat.com>
To: Dmitry Monakhov <dmonakhov@openvz.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>, LKML <linux-kernel@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>, Steve Best <sbest@redhat.com>,
        linux-ext4@vger.kernel.org, Lukas Czerner <lczerner@redhat.com>,
        stable@vger.kernel.org
Message-ID: <1158933859.1177381.1364973284305.JavaMail.root@redhat.com>
In-Reply-To: <876098945.1097253.1364961617725.JavaMail.root@redhat.com>
References: <2133129347.8273339.1364549222854.JavaMail.root@redhat.com> <87ip46ss0o.fsf@openvz.org> <1211053180.322948.1364797847717.JavaMail.root@redhat.com> <87fvzaspr8.fsf@openvz.org> <874841142.414482.1364875584266.JavaMail.root@redhat.com> <874nfps133.fsf@openvz.org> <876098945.1097253.1364961617725.JavaMail.root@redhat.com>
Subject: Re: bisected! (WAS Re: s390x: kernel BUG at fs/ext4/inode.c:1591!)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.5.82.12]
X-Mailer: Zimbra 8.0.3_GA_5664 (ZimbraWebClient - FF19 (Linux)/8.0.3_GA_5664)
Thread-Topic: bisected! (WAS Re: s390x: kernel BUG at fs/ext4/inode.c:1591!)
Thread-Index: MXDhEXrWI58dY+sJ5J8+TLrb0+WpbjVWn/Ea
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > [Text Documents:disable-es_lookup_extent.patch]
With this patch, I cannot reproduce it any more.

CAI Qian
