Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757960Ab3G3WcN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 18:32:13 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:48045 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756345Ab3G3WcM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 18:32:12 -0400
Date: Tue, 30 Jul 2013 15:33:28 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
Cc: Andreas Dilger <andreas.dilger@intel.com>, Peng Tao <tao.peng@emc.com>,
        linux-kernel@vger.kernel.org
Subject: Re: next-20130730 - Seen in drivers/staging/lustre/lnet/Kconfig
Message-ID: <20130730223328.GA13665@kroah.com>
References: <11551.1375222608@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <11551.1375222608@turing-police.cc.vt.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 30, 2013 at 06:16:48PM -0400, Valdis Kletnieks wrote:
> What's wrong with this picture?
> 
> config LNET_MAX_PAYLOAD
>         int "Lustre lnet max transfer payload (default 2MB)"
>         depends on LUSTRE_FS
>         default "1048576"

Loads, patches for drivers/staging/ are always welcome :)

thanks,

greg k-h
