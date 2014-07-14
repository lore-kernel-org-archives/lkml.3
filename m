Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932186AbaGNRfQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 13:35:16 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33660 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751148AbaGNRfK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 13:35:10 -0400
Date: Mon, 14 Jul 2014 10:39:42 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        boris.ostrovsky@oracle.com, david.vrabel@citrix.com
Subject: Re: [PATCH v5 3/6] driver core: Provide an wrapper around the mutex
 to do lockdep warnings
Message-ID: <20140714173942.GA6166@kroah.com>
References: <1405354736-7358-1-git-send-email-konrad.wilk@oracle.com>
 <1405354736-7358-4-git-send-email-konrad.wilk@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1405354736-7358-4-git-send-email-konrad.wilk@oracle.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 14, 2014 at 12:18:53PM -0400, Konrad Rzeszutek Wilk wrote:
> Instead of open-coding it in drivers that want to double check
> that their functions are indeed holding the device lock.
> 
> CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
