Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933594AbaLEDLw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 22:11:52 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:40033 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932098AbaLEDLu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 22:11:50 -0500
Date: Wed, 3 Dec 2014 05:18:18 -0800
From: Darren Hart <dvhart@infradead.org>
To: Gabriele Mazzotta <gabriele.mzt@gmail.com>
Cc: mjg59@srcf.ucam.org, linux-api@vger.kernel.org,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
        libsmbios-devel@lists.us.dell.com, Srinivas_G_Gowda@dell.com,
        Michael_E_Brown@dell.com, pali.rohar@gmail.com
Subject: Re: [PATCH] Documentation: Add entry for dell-laptop sysfs interface
Message-ID: <20141203131817.GE75099@vmdeb7>
References: <1417628493-29323-1-git-send-email-gabriele.mzt@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1417628493-29323-1-git-send-email-gabriele.mzt@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 03, 2014 at 06:41:33PM +0100, Gabriele Mazzotta wrote:
> Add the documentation for the new sysfs interface of dell-laptop
> that allows to configure the keyboard illumination on Dell systems.
> 
> Signed-off-by: Gabriele Mazzotta <gabriele.mzt@gmail.com>
> Signed-off-by: Pali Rohár <pali.rohar@gmail.com>

If nobody else would prefer to take this in their tree, I'll submit it through
platform-drivers-x86 when I send the corresponding driver patch.

-- 
Darren Hart
Intel Open Source Technology Center
