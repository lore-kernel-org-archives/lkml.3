Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932895Ab3D2WrZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 18:47:25 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:61395 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756690Ab3D2WrY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 18:47:24 -0400
Date: Mon, 29 Apr 2013 15:47:21 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Jerry Hoemann <jerry.hoemann@hp.com>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        jacob.shin@amd.com, yinghai@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86/mm: account for PGDIR_SIZE alignment
Message-ID: <20130429224721.GA587@kroah.com>
References: <1367275129-22383-1-git-send-email-jerry.hoemann@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1367275129-22383-1-git-send-email-jerry.hoemann@hp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 29, 2013 at 04:38:49PM -0600, Jerry Hoemann wrote:
> Patch for 3.0-stable.  Function find_early_table_space removed upstream.

No other stable kernel needs it?  Why not also cc:
stable@vger.kernel.org about this?

thanks,

greg k-h
