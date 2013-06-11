Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754142Ab3FKJqz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 05:46:55 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:37746 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753341Ab3FKJqx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 05:46:53 -0400
Date: Tue, 11 Jun 2013 02:46:52 -0700 (PDT)
Message-Id: <20130611.024652.352722242220532694.davem@davemloft.net>
To: mst@redhat.com
Cc: netdev@vger.kernel.org, asias@redhat.com, tt.rantala@gmail.com,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net 1/2] vhost: check owner before we overwrite
 ubuf_info
From: David Miller <davem@davemloft.net>
In-Reply-To: <1370521145-9723-2-git-send-email-mst@redhat.com>
References: <1370521145-9723-1-git-send-email-mst@redhat.com>
	<1370521145-9723-2-git-send-email-mst@redhat.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Michael S. Tsirkin" <mst@redhat.com>
Date: Thu, 6 Jun 2013 15:20:39 +0300

> If device has an owner, we shouldn't touch ubuf_info
> since it might be in use.
> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

Applied.
