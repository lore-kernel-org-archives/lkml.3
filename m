Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752470AbaCIDWc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2014 22:22:32 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:53497 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751981AbaCIDWb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2014 22:22:31 -0500
Date: Sat, 8 Mar 2014 19:23:07 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Peng Tao <bergwolf@gmail.com>
Cc: linux-kernel@vger.kernel.org, Andreas Dilger <andreas.dilger@intel.com>,
        Oleg Drokin <oleg.drokin@intel.com>
Subject: Re: [PATCH 1/6] staging/lustre/lnet: remove kiblnd_debug_conn/rx/tx
Message-ID: <20140309032307.GA12665@kroah.com>
References: <1394026040-1968-1-git-send-email-bergwolf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1394026040-1968-1-git-send-email-bergwolf@gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 05, 2014 at 09:27:15PM +0800, Peng Tao wrote:
> They are not called by anyone and cause gcc warning:
> drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c:609: warning: ‘kiblnd_debug_conn’
> defined but not used
> drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c:589: warning: ‘kiblnd_debug_rx’
> defined but not used
> drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c:597: warning: ‘kiblnd_debug_tx’
> defined but not used

Don't wrap error messages, it's not needed.
