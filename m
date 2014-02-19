Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753813AbaBSN61 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 08:58:27 -0500
Received: from smtp-outbound-1.vmware.com ([208.91.2.12]:48976 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753791AbaBSN6X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 08:58:23 -0500
Message-ID: <5304B87B.6040804@vmware.com>
Date: Wed, 19 Feb 2014 14:58:19 +0100
From: Thomas Hellstrom <thellstrom@vmware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Maarten Lankhorst <maarten.lankhorst@canonical.com>
CC: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
        ccross@google.com, linux-media@vger.kernel.org
Subject: Re: [PATCH 3/6] dma-buf: use reservation objects
References: <20140217155056.20337.25254.stgit@patser> <20140217155617.20337.22601.stgit@patser>
In-Reply-To: <20140217155617.20337.22601.stgit@patser>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/17/2014 04:56 PM, Maarten Lankhorst wrote:
> This allows reservation objects to be used in dma-buf. it's required
> for implementing polling support on the fences that belong to a dma-buf.
>
> Signed-off-by: Maarten Lankhorst <maarten.lankhorst@canonical.com>
> Acked-by: Mauro Carvalho Chehab <m.chehab@samsung.com> #drivers/media/v4l2-core/

For the TTM part:

 Acked-by: Thomas Hellstrom <thellstrom@vmware.com>
