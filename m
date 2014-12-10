Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932912AbaLJTAa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 14:00:30 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:56139 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932501AbaLJTA1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 14:00:27 -0500
Date: Wed, 10 Dec 2014 14:00:25 -0500
From: Greg KH <gregkh@linuxfoundation.org>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: linux-kernel@vger.kernel.org, devel@linuxdriverproject.org, olaf@aepfle.de,
        apw@canonical.com, jasowang@redhat.com, mcb30@ipxe.org
Subject: Re: [PATCH 1/1] Drivers: hv: vmbus: Fix a bug in
 vmbus_establish_gpadl()
Message-ID: <20141210190025.GA2015@kroah.com>
References: <1418240563-6590-1-git-send-email-kys@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1418240563-6590-1-git-send-email-kys@microsoft.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 10, 2014 at 11:42:43AM -0800, K. Y. Srinivasan wrote:
> Fix a bug in vmbus_establish_gpadl(). I would like to
> thank Michael Brown <mcb30@ipxe.org> for seeing this bug.

Then use the "Reported-by:" tag with his name in this patch please.

thanks,

greg k-h
