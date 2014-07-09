Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754338AbaGIVLv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 17:11:51 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:48222 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751010AbaGIVLu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 17:11:50 -0400
Date: Wed, 9 Jul 2014 14:16:15 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Kleber Sacilotto de Souza <klebers@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, haver@linux.vnet.ibm.com
Subject: Re: [PATCH 0/4] GenWQE: patches to improve RAS features (v2)
Message-ID: <20140709211615.GA6818@kroah.com>
References: <1403713327-27976-1-git-send-email-klebers@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1403713327-27976-1-git-send-email-klebers@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 25, 2014 at 01:22:03PM -0300, Kleber Sacilotto de Souza wrote:
> Hi,
> 
> I'm sending a v2 of this patch series, removing the patch that bumps the
> driver version number, and including a trivial one that removes an unnecessary
> include.

Oops, I just took the first version of this :(

Care to send a single patch to remove the "unnecessary" include?

thanks,

greg k-h
