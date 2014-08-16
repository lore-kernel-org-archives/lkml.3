Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751493AbaHPMgi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2014 08:36:38 -0400
Received: from mail-qc0-f179.google.com ([209.85.216.179]:44347 "EHLO
	mail-qc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751387AbaHPMgg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2014 08:36:36 -0400
Date: Sat, 16 Aug 2014 08:36:33 -0400
From: Tejun Heo <tj@kernel.org>
To: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Cc: Hans de Goede <hdegoede@redhat.com>, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ata: remove deprecated struct ahci_platform_data
Message-ID: <20140816123633.GE9305@htj.dyndns.org>
References: <4376282.p3rdI3v8uT@amdc1032>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4376282.p3rdI3v8uT@amdc1032>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 12, 2014 at 06:22:27PM +0200, Bartlomiej Zolnierkiewicz wrote:
> The last user of the deprecated struct ahci_platform_data has been
> cleaned up recently (SPEAr1340 got a proper PHY driver).
> 
> Cc: Hans de Goede <hdegoede@redhat.com>
> Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>

Applied to libata/for-3.18.

Thanks!

-- 
tejun
