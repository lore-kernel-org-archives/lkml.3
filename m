Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752682Ab3LZGgI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Dec 2013 01:36:08 -0500
Received: from mail-ob0-f170.google.com ([209.85.214.170]:50476 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751047Ab3LZGgG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Dec 2013 01:36:06 -0500
MIME-Version: 1.0
In-Reply-To: <1387999653-22139-1-git-send-email-mst@redhat.com>
References: <1387983339-1172-1-git-send-email-mst@redhat.com> <1387999653-22139-1-git-send-email-mst@redhat.com>
From: Michael Dalton <mwdalton@google.com>
Date: Wed, 25 Dec 2013 22:35:46 -0800
Message-ID: <CANJ5vPJAmahQxYFFNhrNuvOxBJeWF42fODWZ0uoMdE8ZKQHqtw@mail.gmail.com>
Subject: Re: [PATCH stable] virtio_net: don't leak memory or block when too
 many frags
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: netdev@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
        David Miller <davem@davemloft.net>,
        lf-virt <virtualization@lists.linux-foundation.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Michael Dalton <mwdalton@google.com>
