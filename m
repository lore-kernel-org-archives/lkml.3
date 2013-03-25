Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932759Ab3CYSWc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 14:22:32 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:37071 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932576Ab3CYSW3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 14:22:29 -0400
Date: Mon, 25 Mar 2013 11:22:26 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Eduardo Valentin <eduardo.valentin@ti.com>
Cc: devel@driverdev.osuosl.org, Nishanth Menon <nm@ti.com>,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org
Subject: Re: [PATCHv2 09/12] staging: ti-soc-thermal: fix several kernel-doc
 warnings and error
Message-ID: <20130325182226.GA15717@kroah.com>
References: <1363704868-11843-1-git-send-email-eduardo.valentin@ti.com>
 <1363704868-11843-10-git-send-email-eduardo.valentin@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363704868-11843-10-git-send-email-eduardo.valentin@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 19, 2013 at 10:54:25AM -0400, Eduardo Valentin wrote:
> This patch updates the documentation to remove
> all warnings and errors reported by scripts/kernel-doc.
> Most are missing arguments due to wrong format.
> 
> Cc: Nishanth Menon <nm@ti.com>
> 
> Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>

In the future, don't put empty lines between the Cc: and signed-off-by:
lines please, I had to hand-edit all of these to fix that...

greg k-h
