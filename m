Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760965AbaGYTmK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 15:42:10 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:40433 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753520AbaGYTmJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 15:42:09 -0400
Date: Fri, 25 Jul 2014 12:42:04 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Hans de Goede <hdegoede@redhat.com>
Cc: Julian Squires <julian@cipht.net>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Input: wacom_serial4 - prepare for wacom USB moving to
 HID
Message-ID: <20140725194204.GA33031@core.coreip.homeip.net>
References: <20140724203108.GA9191@core.coreip.homeip.net>
 <53D2AAB4.1090109@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53D2AAB4.1090109@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 25, 2014 at 09:06:28PM +0200, Hans de Goede wrote:
> Hi,
> 
> On 07/24/2014 10:31 PM, Dmitry Torokhov wrote:
> > wacom_wac.h will be moving to drivers/hid. Since we only need 3 definitions
> > from it let's simply copy them over.
> > 
> > Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> 
> Ack, but you will want to drop the #include of wacom_wac.h yoo.

Right, that was in my v2 ;)

Thanks.

-- 
Dmitry
