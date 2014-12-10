Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933014AbaLJTO1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 14:14:27 -0500
Received: from mx1.redhat.com ([209.132.183.28]:58189 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932656AbaLJTO0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 14:14:26 -0500
Date: Wed, 10 Dec 2014 21:14:10 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: David Miller <davem@davemloft.net>, cornelia.huck@de.ibm.com,
        rusty@au1.ibm.com, nab@linux-iscsi.org, pbonzini@redhat.com,
        thuth@linux.vnet.ibm.com, dahi@linux.vnet.ibm.com
Subject: Re: [PATCH v8 00/50] linux: towards virtio-1 guest support
Message-ID: <20141210191410.GA4012@redhat.com>
References: <1417449619-24896-1-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417449619-24896-1-git-send-email-mst@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OK, so far I got positive test reports from Cornelia, so tomorrow, I'm
going to send a pull request with the following:
- this huge patchset
- virtio 1.0 enhancements
- virtio_ccw: minor enhancements

Everything can be found in my tree, vhost-next branch.

-- 
MST
