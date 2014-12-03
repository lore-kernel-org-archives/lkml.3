Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751414AbaLFEio (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 23:38:44 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:49606 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750744AbaLFEim (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 23:38:42 -0500
Date: Wed, 3 Dec 2014 10:07:57 -0800
From: Darren Hart <dvhart@infradead.org>
To: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
Cc: platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: Re: [PATCH v2] dell-smo8800: Add more ACPI ids and change
 description of driver
Message-ID: <20141203180756.GC20370@vmdeb7>
References: <20141203134323.GI75099@vmdeb7>
 <1417781146-6261-1-git-send-email-pali.rohar@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1417781146-6261-1-git-send-email-pali.rohar@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 05, 2014 at 01:05:46PM +0100, Pali Rohár wrote:
> This patch adds other ACPI ids from Windows inf driver which should be handled
> by dell-smo8800 driver. ACPI devices have same structure -- one IRQ number.
> 
> This patch also updates description of module.
> 
> Signed-off-by: Pali Rohár <pali.rohar@gmail.com>

Queued to testing, thanks Pali.

-- 
Darren Hart
Intel Open Source Technology Center
