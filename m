Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756542Ab3AWS2p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 13:28:45 -0500
Received: from server.prisktech.co.nz ([115.188.14.127]:53085 "EHLO
	server.prisktech.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756194Ab3AWS2o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 13:28:44 -0500
Message-ID: <1358965730.13715.0.camel@gitbox>
Subject: Re: [PATCH v3 1/2] mtd: Add a common JEDEC flash device table
From: Tony Prisk <linux@prisktech.co.nz>
To: vt8500-wm8505-linux-kernel@googlegroups.com
Cc: "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "dedekind1@gmail.com" <dedekind1@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Date: Thu, 24 Jan 2013 07:28:50 +1300
In-Reply-To: <50FFA692.2060907@parrot.com>
References: <1358928068-12417-1-git-send-email-linux@prisktech.co.nz>
	 <1358928068-12417-2-git-send-email-linux@prisktech.co.nz>
	 <50FFA692.2060907@parrot.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-01-23 at 10:00 +0100, Matthieu CASTET wrote:
> Tony Prisk a écrit :
> > This patch adds a common JEDEC flash device table which can be
> > expanded on as more features are required.
> > 
> > A simple match function is also included to query the table for
> > a match based on the JEDEC id.
> 
> Why don't you use id from include/linux/mtd/cfi.h that is used by flash driver
> like drivers/mtd/devices/m25p80.c ?
> 

Thanks - have changed for v4.

Regards
Tony P

