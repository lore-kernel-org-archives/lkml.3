Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753113AbaLLXs2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 18:48:28 -0500
Received: from mail.linux-iscsi.org ([67.23.28.174]:41704 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751175AbaLLXs1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 18:48:27 -0500
Message-ID: <1418428105.10743.84.camel@haakon3.risingtidesystems.com>
Subject: Re: [PATCH v8 00/50] linux: towards virtio-1 guest support
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>,
        cornelia.huck@de.ibm.com, rusty@au1.ibm.com, pbonzini@redhat.com,
        thuth@linux.vnet.ibm.com, dahi@linux.vnet.ibm.com
Date: Fri, 12 Dec 2014 15:48:25 -0800
In-Reply-To: <20141210191410.GA4012@redhat.com>
References: <1417449619-24896-1-git-send-email-mst@redhat.com>
	 <20141210191410.GA4012@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi MST,

On Wed, 2014-12-10 at 21:14 +0200, Michael S. Tsirkin wrote:
> OK, so far I got positive test reports from Cornelia, so tomorrow, I'm
> going to send a pull request with the following:
> - this huge patchset
> - virtio 1.0 enhancements
> - virtio_ccw: minor enhancements
> 
> Everything can be found in my tree, vhost-next branch.
> 

Apologies for the lack of response on the vhost-scsi part of this
series..

The partial conversion looks fine, and just a head up that I'll be
spending time on this for v3.20 code to add proper any-layout -> virtio
1.0 spec support into vhost-scsi.

Thank you,

--nab

