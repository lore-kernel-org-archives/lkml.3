Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756006AbaHZWpx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 18:45:53 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:34011 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755673AbaHZWpv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 18:45:51 -0400
Date: Tue, 26 Aug 2014 15:45:47 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Felipe Balbi <balbi@ti.com>
Cc: Dan Murphy <dmurphy@ti.com>, devicetree@vger.kernel.org,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2] doc: dt/bindings: input: Fix drv260x binding document
Message-ID: <20140826224547.GB8377@core.coreip.homeip.net>
References: <1408727539-15996-1-git-send-email-dmurphy@ti.com>
 <20140822171641.GE27616@saruman.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140822171641.GE27616@saruman.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 22, 2014 at 12:16:41PM -0500, Felipe Balbi wrote:
> On Fri, Aug 22, 2014 at 12:12:19PM -0500, Dan Murphy wrote:
> > Update the drv260x dt binding document:
> > - Change the node name to the devices function not the
> > device name.
> > - Add vbat-supply to the example.
> > - Fix indentation of the example.
> > 
> > Signed-off-by: Dan Murphy <dmurphy@ti.com>
> 
> Reviewed-by: Felipe Balbi <balbi@ti.com>

Applied, thank you.

-- 
Dmitry
