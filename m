Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754676AbaDGAg0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Apr 2014 20:36:26 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:58142 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754135AbaDGAgY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Apr 2014 20:36:24 -0400
Date: Sun, 6 Apr 2014 17:38:53 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Joel Pelaez Jorge <joelpelaez@gmail.com>
Cc: Silvan Jegen <s.jegen@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] Staging: rtl8192e: Fix code issues
Message-ID: <20140407003853.GD13365@kroah.com>
References: <5341C643.4050700@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5341C643.4050700@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 06, 2014 at 04:25:23PM -0500, Joel Pelaez Jorge wrote:
> In the kernel driver: rtl8192e, exists some problems related
> to source check, using the tool sparse, but for fix it, is necessary
> remove a bad declaration that keep off the patch.
> 
> Because it is resolved before apply the "main" patch.
> 
> Joel Pelaez Jorge (2):
>   Staging: rtl8192e: Remove bad 'extern' declaration
>   Staging: rtl8192e: Fix sparse warning

This email says "0/3", yet you only have 2 patches?

confused,

greg k-h
