Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934727Ab3BTSSV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 13:18:21 -0500
Received: from mail-da0-f53.google.com ([209.85.210.53]:42757 "EHLO
	mail-da0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933919Ab3BTSST (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 13:18:19 -0500
Date: Wed, 20 Feb 2013 10:18:15 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Simon Glass <sjg@chromium.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Bill Pemberton <wfp5p@virginia.edu>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Javier Martinez Canillas <javier@dowhile0.org>,
        Sourav Poddar <sourav.poddar@ti.com>, Felipe Balbi <balbi@ti.com>,
        Alban Bedel <alban.bedel@avionic-design.de>,
        linux-input@vger.kernel.org
Subject: Re: [PATCH v5 5/6] Input: matrix-keymap: Add function to read the
 new DT binding
Message-ID: <20130220181815.GB15152@core.coreip.homeip.net>
References: <1361381079-26747-1-git-send-email-sjg@chromium.org>
 <1361381079-26747-6-git-send-email-sjg@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1361381079-26747-6-git-send-email-sjg@chromium.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 20, 2013 at 09:24:38AM -0800, Simon Glass wrote:
> We now have a binding which adds two parameters to the matrix keypad DT
> node. This is separate from the GPIO-driven matrix keypad binding, and
> unfortunately incompatible, since that uses row-gpios/col-gpios for the
> row and column counts.
> 
> So the easiest option here is to provide a function for non-GPIO drivers
> to use to decode the binding.
> 
> Note: We could in fact create an entirely separate structure to hold
> these two fields, but it does not seem worth it, yet. If we have more
> parameters then we can add this, and then refactor each driver to hold
> such a structure.
> 
> Signed-off-by: Simon Glass <sjg@chromium.org>
> Tested-by: Sourav Poddar <sourav.poddar@ti.com> (v2)

Acked-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>

I suppose the EC driver will go through MFD tree, right?

-- 
Dmitry
