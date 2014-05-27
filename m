Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753118AbaE0U5e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 16:57:34 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43307 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751540AbaE0U5d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 16:57:33 -0400
Date: Tue, 27 May 2014 22:57:30 +0200
From: Jean Delvare <jdelvare@suse.de>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/5] driver core: Clean up dev_get/set_drvdata
Message-ID: <20140527225730.08dde3fa@endymion.delvare>
In-Reply-To: <20140527205036.GA4888@kroah.com>
References: <20140414124802.2859439e@endymion.delvare>
	<20140527205036.GA4888@kroah.com>
Organization: SUSE Linux
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 May 2014 13:50:36 -0700, Greg KH wrote:
> On Mon, Apr 14, 2014 at 12:48:02PM +0200, Jean Delvare wrote:
> > This patch set is a proposal to revert most of commit b4028437. This
> > would solve a memory leak and also allow to simplify and ultimately
> > inline again functions dev_get_drvdata and dev_set_drvdata for smaller
> > footprint and improved performance.
> > 
> > [PATCH 1/5] driver core: Move driver_data back to struct device
> > [PATCH 2/5] driver core: dev_set_drvdata can no longer fail
> > [PATCH 3/5] driver core: dev_set_drvdata returns void
> > [PATCH 4/5] driver core: dev_get_drvdata: Don't check for NULL dev
> > [PATCH 5/5] driver core: Inline dev_set/get_drvdata
> > 
> 
> Sorry for the long delay, these are finally all now applied to my tree.

Cool, thanks!

-- 
Jean Delvare
SUSE L3 Support
