Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755209Ab3EURDG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 13:03:06 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56712 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753061Ab3EURDD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 13:03:03 -0400
Date: Tue, 21 May 2013 10:03:02 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Eduardo Valentin <eduardo.valentin@ti.com>
Cc: rui.zhang@intel.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
Subject: Re: [PATCH 0/2] staging -> thermal: move ti-soc-thermal to
 drivers/thermal
Message-ID: <20130521170302.GC20464@kroah.com>
References: <1368632761-10528-1-git-send-email-eduardo.valentin@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1368632761-10528-1-git-send-email-eduardo.valentin@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 15, 2013 at 11:45:59AM -0400, Eduardo Valentin wrote:
> 
> Hello Greg and Rui,
> 
> I am proposing to move the ti-soc-thermal driver from drivers/stating/
> to drivers/thermal. It has been some time that we have been fixing and
> improving the code under staging tree.

This is up to review from the thermal maintainer and developers to
accept this.

thanks,

greg k-h
