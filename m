Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755381Ab3FRI6U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 04:58:20 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54000 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755042Ab3FRI6P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 04:58:15 -0400
Date: Tue, 18 Jun 2013 10:58:13 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc: Andrew Duggan <aduggan@synaptics.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] HID: i2c-hid: support sending HID output reports
 using the output register
In-Reply-To: <51C019DB.5070106@redhat.com>
Message-ID: <alpine.LNX.2.00.1306181057580.6750@pobox.suse.cz>
References: <1371510906-16859-1-git-send-email-aduggan@synaptics.com> <51C019DB.5070106@redhat.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Jun 2013, Benjamin Tissoires wrote:

> On 06/18/2013 01:15 AM, Andrew Duggan wrote:
> > The current i2c hid driver does not support sending HID output reports using
> > the output register for devices which support receiving reports through this
> > method. This patch determines which method to use to send output reports based
> >  on the value of wMaxOutputLength in the device's HID descriptor.
> > 
> > Signed-off-by: Andrew Duggan <aduggan@synaptics.com>
> 
> Reviewed-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>

Applied, thanks guys.

-- 
Jiri Kosina
SUSE Labs
