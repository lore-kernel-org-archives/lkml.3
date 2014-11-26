Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751635AbaKZIsk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 03:48:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:35063 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750809AbaKZIsi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 03:48:38 -0500
Message-ID: <1416991708.10813.4.camel@nilsson.home.kraxel.org>
Subject: Re: [PATCH v4 18/42] virtio_blk: make serial attribute static
From: Gerd Hoffmann <kraxel@redhat.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, rusty@au1.ibm.com,
        virtualization@lists.linux-foundation.org, pbonzini@redhat.com,
        David Miller <davem@davemloft.net>
Date: Wed, 26 Nov 2014 09:48:28 +0100
In-Reply-To: <1416933600-21398-19-git-send-email-mst@redhat.com>
References: <1416933600-21398-1-git-send-email-mst@redhat.com>
	 <1416933600-21398-19-git-send-email-mst@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Di, 2014-11-25 at 18:42 +0200, Michael S. Tsirkin wrote:
> It's never declared so no need to make it extern.

Hmm, can't see patches 14 -> 17 on the maling list
(virtualization@lists.linux-foundation.org).  Also no cover letter.
Someone eating mails?

cheers,
  Gerd


