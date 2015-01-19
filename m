Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752404AbbASKyv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 05:54:51 -0500
Received: from mx1.redhat.com ([209.132.183.28]:39598 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752281AbbASKys (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 05:54:48 -0500
Message-ID: <1421664883.3610.1.camel@nilsson.home.kraxel.org>
Subject: Re: [PATCH v3 00/16] virtio-pci: towards virtio 1.0 guest support
From: Gerd Hoffmann <kraxel@redhat.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org
Date: Mon, 19 Jan 2015 11:54:43 +0100
In-Reply-To: <1421414833.21318.67.camel@nilsson.home.kraxel.org>
References: <1421256142-11512-1-git-send-email-mst@redhat.com>
	 <1421356698.3933.18.camel@nilsson.home.kraxel.org>
	 <20150115213256.GA4813@redhat.com>
	 <1421397146.21318.16.camel@nilsson.home.kraxel.org>
	 <20150116084541.GA29204@redhat.com>
	 <1421414833.21318.67.camel@nilsson.home.kraxel.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hi,

> I'm running 3.19-rc4 with this series applied in the guest, maybe I need
> more?

Tried your vhost branch, rebased to 3.19-rc5 -- same result.  Hmm.

cheers,
  Gerd


