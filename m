Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935240Ab3IDP5J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 11:57:09 -0400
Received: from mail-ee0-f45.google.com ([74.125.83.45]:49943 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934929Ab3IDP5I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 11:57:08 -0400
Date: Wed, 4 Sep 2013 17:56:56 +0200
From: Richard Cochran <richardcochran@gmail.com>
To: Jason Wang <jasowang@redhat.com>
Cc: davem@davemloft.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        mst@redhat.com
Subject: Re: [PATCH net-next 1/2] tuntap: purge socket error queue on detach
Message-ID: <20130904155656.GB4194@netboy>
References: <1378269226-5969-1-git-send-email-jasowang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1378269226-5969-1-git-send-email-jasowang@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 04, 2013 at 12:33:45PM +0800, Jason Wang wrote:
> Commit eda297729171fe16bf34fe5b0419dfb69060f623
> (tun: Support software transmit time stamping) will queue skbs into error queue
> when tx stamping is enabled. But it forgets to purge the error queue during
> detach. This patch fixes this.
> 
> Cc: Richard Cochran <richardcochran@gmail.com>
> Signed-off-by: Jason Wang <jasowang@redhat.com>

Acked-by: Richard Cochran <richardcochran@gmail.com>
