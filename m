Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757047Ab3D3GsX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 02:48:23 -0400
Received: from shutemov.name ([204.155.152.216]:37875 "EHLO shutemov.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753037Ab3D3GsW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 02:48:22 -0400
X-Greylist: delayed 611 seconds by postgrey-1.27 at vger.kernel.org; Tue, 30 Apr 2013 02:48:22 EDT
Date: Tue, 30 Apr 2013 10:31:45 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Serban Constantinescu <serban.constantinescu@arm.com>
Cc: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        kernel-team@android.com, arve@android.com, john.stultz@linaro.org,
        Dave.Butcher@arm.com
Subject: Re: [PATCH v3 0/6] Android Binder IPC Fixes
Message-ID: <20130430073145.GA3623@shutemov.name>
References: <1365769555-6052-1-git-send-email-serban.constantinescu@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1365769555-6052-1-git-send-email-serban.constantinescu@arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 12, 2013 at 01:25:49PM +0100, Serban Constantinescu wrote:
> The patch set has been successfully tested with a 64bit Linux userspace and
> 64bit binder unit-tests.
> 
> This patch set has been successfully tested on 32bit platforms(ARMv7 VExpress)
> and 64bit platforms(ARMv8 RTSM) running a 32bit Android userspace and an in
> kernel binder compat layer.

I've tried to replace ugly hack with your patches to be able to boot
32-bit userspace on x86-64. It fails. :(

-- 
 Kirill A. Shutemov
