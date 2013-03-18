Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753961Ab3CRRBl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 13:01:41 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:59348 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753254Ab3CRRBj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 13:01:39 -0400
Date: Mon, 18 Mar 2013 13:01:36 -0400 (EDT)
Message-Id: <20130318.130136.1629094222097780420.davem@davemloft.net>
To: mst@redhat.com
Cc: kvm@vger.kernel.org, virtualization@lists.osdl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, asias@redhat.com, nab@linux-iscsi.org,
        target-devel@vger.kernel.org
Subject: Re: [PULL] vhost: tcm_vhost fixes for 3.9
From: David Miller <davem@davemloft.net>
In-Reply-To: <20130318112003.GA7809@redhat.com>
References: <20130318112003.GA7809@redhat.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Mon, 18 Mar 2013 10:01:43 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Michael S. Tsirkin" <mst@redhat.com>
Date: Mon, 18 Mar 2013 13:20:03 +0200

> The following changes since commit 8c6216d7f118a128678270824b6a1286a63863ca:
> 
>   Revert "ip_gre: make ipgre_tunnel_xmit() not parse network header as IP unconditionally" (2013-03-16 23:00:41 -0400)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git vhost-net
> 
> for you to fetch changes up to deb7cb067dabd3be625eaf5495da8bdc97377fc1:
> 
>   tcm_vhost: Flush vhost_work in vhost_scsi_flush() (2013-03-17 13:04:14 +0200)

This is a scsi driver, I therefore don't think this pull request is for me.

Please avoid such confusion in the future, and don't use branch names
like "vhost-net" for SCSI driver fixes.

Thanks.
