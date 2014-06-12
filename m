Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751602AbaFLR7U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 13:59:20 -0400
Received: from mail.linux-iscsi.org ([67.23.28.174]:43255 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751330AbaFLR7S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 13:59:18 -0400
Message-ID: <1402595943.18202.0.camel@haakon3.risingtidesystems.com>
Subject: Re: [PATCH] vhost-scsi: don't open-code kvfree
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Date: Thu, 12 Jun 2014 10:59:03 -0700
In-Reply-To: <1402588896-25446-1-git-send-email-mst@redhat.com>
References: <1402588896-25446-1-git-send-email-mst@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-06-12 at 19:02 +0300, Michael S. Tsirkin wrote:
> Now that we have kvfree, use it in vhost-scsi instead of
> the open-coded version.
> 
> Cc: Nicholas Bellinger <nab@linux-iscsi.org>
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> ---
> 
> I have this queued for -rc2.
> Nicholas could you review ack pls?


Reviewed-by + Acked-by: Nicholas Bellinger <nab@linux-iscsi.org>

Thanks MST!

