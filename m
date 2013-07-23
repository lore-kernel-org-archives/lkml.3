Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934174Ab3GWTgF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 15:36:05 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39378 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933986Ab3GWTgB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 15:36:01 -0400
Date: Tue, 23 Jul 2013 12:37:12 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Peng Tao <bergwolf@gmail.com>
Cc: linux-kernel@vger.kernel.org, Peng Tao <tao.peng@emc.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: Re: [PATCH 02/48] staging/lustre/obdclass: restore lu_ref
Message-ID: <20130723193712.GA9385@kroah.com>
References: <1374509230-3324-1-git-send-email-bergwolf@gmail.com>
 <1374509230-3324-3-git-send-email-bergwolf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1374509230-3324-3-git-send-email-bergwolf@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 23, 2013 at 12:06:23AM +0800, Peng Tao wrote:
> lu_ref.[ch] were mistakenly removed by coan2. Add them back and guard
> with CONFIG_LUSTRE_DEBUG_LU_REF_CHECK.

Ick, why?  Why not use the in-kernel infrastructure for this type of
thig, _iff_ you really need it.

Why do you need this at all, isn't the reference code fully debugged by
now, given that this has been running for years?  I would only expect to
see something like this in new code that is still being developed.

thanks,

greg k-h
