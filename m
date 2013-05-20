Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758036Ab3ETUGt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 16:06:49 -0400
Received: from mout.gmx.net ([212.227.17.22]:53808 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756919Ab3ETUGs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 16:06:48 -0400
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX191xa4MYjN19Z8afP9hXyoJTyL72e2c2oDfurlb9d
	XFKujmlbwJ/LnD
From: Peter =?iso-8859-15?q?H=FCwe?= <PeterHuewe@gmx.de>
To: Michael Hennerich <michael.hennerich@analog.com>
Subject: Re: [PATCH] mfd/adp5520: Use module_i2c_driver to register driver
Date: Mon, 20 May 2013 22:11:54 +0200
User-Agent: KMail/1.13.7 (Linux/3.8.11; KDE/4.9.5; x86_64; ; )
Cc: Samuel Ortiz <sameo@linux.intel.com>,
        device-drivers-devel@blackfin.uclinux.org,
        linux-kernel@vger.kernel.org
References: <1369078115-25377-1-git-send-email-peterhuewe@gmx.de>
In-Reply-To: <1369078115-25377-1-git-send-email-peterhuewe@gmx.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201305202211.54422.PeterHuewe@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, 20. Mai 2013, 21:28:35 schrieb Peter Huewe:
> Removing some boilerplate by using module_i2c_driver instead of calling
> register and unregister in the otherwise empty init/exit functions
> 
> Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
Sorry for the noise 

 099bb952b064  mfd: adp5520: Use module_i2c_driver() by Sachin Kamat

I was working on an stale tree - sorry.
Please ignore this patch.

Peter
