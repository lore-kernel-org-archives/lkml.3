Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757560AbbA0DNN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 22:13:13 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:52719 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751895AbbA0DNL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 22:13:11 -0500
Date: Mon, 26 Jan 2015 19:13:09 -0800
From: Darren Hart <dvhart@infradead.org>
To: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
Cc: platform-driver-x86@vger.kernel.org,
        Corentin Chary <corentin.chary@gmail.com>,
        acpi4asus-user@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        kernel@savoirfairelinux.com
Subject: Re: [PATCH v3 1/2] asus-laptop: use DEVICE_ATTR_xx macros
Message-ID: <20150127031308.GC3585@vmdeb7>
References: <1422021671-31861-1-git-send-email-vivien.didelot@savoirfairelinux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1422021671-31861-1-git-send-email-vivien.didelot@savoirfairelinux.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 23, 2015 at 09:01:10AM -0500, Vivien Didelot wrote:
> Use DEVICE_ATTR_{RO,WO,RW} macros to simplify sysfs attributes
> declaration.
> 
> To declare a "foo" attribute, DEVICE_ATTR_RW() requires foo_show() and
> foo_store(), so rename a few functions to satisfy this requirement.
> 
> Also put the macro below each related show/store functions for clarity.
> 
> Signed-off-by: Vivien Didelot <vivien.didelot@savoirfairelinux.com>

Thanks for the update. Queued for 3.20.
-- 
Darren Hart
Intel Open Source Technology Center
