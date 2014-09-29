Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754070AbaI2P5n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 11:57:43 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:38487 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752310AbaI2P5m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 11:57:42 -0400
Date: Mon, 29 Sep 2014 11:56:47 -0400
From: Greg KH <gregkh@linuxfoundation.org>
To: Tomas Winkler <tomas.winkler@intel.com>
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org
Subject: Re: [RESEND char-misc-next 00/18] mei: resend of rebased patches
Message-ID: <20140929155647.GA11514@kroah.com>
References: <1411997510-29094-1-git-send-email-tomas.winkler@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411997510-29094-1-git-send-email-tomas.winkler@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 29, 2014 at 04:31:32PM +0300, Tomas Winkler wrote:
> Resend of two series that haven't applied 
> 1. Remove pci dependencies from mei module to support testing hw module 
> 2. Overall documentation formating fix and other collateral fixes.
> 
> Added two more cleanups:
> mei: drop me_client_presentation_num
> mei: trivial: fix errors in prints in comments

Thanks for redoing these, all now applied.

greg k-h
