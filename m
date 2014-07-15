Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754695AbaGOPap (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 11:30:45 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:42122 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752139AbaGOPam (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 11:30:42 -0400
Date: Tue, 15 Jul 2014 08:30:19 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Daeseok Youn <daeseok.youn@gmail.com>
Cc: lidza.louina@gmail.com, markh@compro.net, devel@driverdev.osuosl.org,
        driverdev-devel@linuxdriverproject.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/8 RESEND] staging: dgap: introduce dgap_cleanup_nodes()
Message-ID: <20140715153019.GB8844@kroah.com>
References: <20140715091425.GA19095@devel.8.8.4.4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140715091425.GA19095@devel.8.8.4.4>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 15, 2014 at 06:14:25PM +0900, Daeseok Youn wrote:
> When a configration file is parsed with dgap_parsefile(),
> makes nodes for saving configrations for board.

configuration files should not be parsed in the kernel at all.  That
logic should be removed as it should not be needed.

Mark, can you verify that this is not needed with your hardware anymore?

thanks,

greg k-h
