Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753531AbbANOHZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 09:07:25 -0500
Received: from mail-wg0-f51.google.com ([74.125.82.51]:54127 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752601AbbANOHY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 09:07:24 -0500
From: Gabriele Mazzotta <gabriele.mzt@gmail.com>
To: dvhart@infradead.org
Cc: mjg59@srcf.ucam.org, pali.rohar@gmail.com, linux-kernel@vger.kernel.org,
        platform-driver-x86@vger.kernel.org, A.Sloman@cs.bham.ac.uk,
        computersforpeace@gmail.com
Subject: Re: [PATCH] dell-laptop: use dedicated sysfs file for ALS
Date: Wed, 14 Jan 2015 15:07:21 +0100
Message-ID: <9352624.oIKUSW0aDp@xps13>
In-Reply-To: <1421244357-31103-1-git-send-email-gabriele.mzt@gmail.com>
References: <1421244357-31103-1-git-send-email-gabriele.mzt@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I decided to remove "als" from input_triggers and created a dedicated
sysfs file for it. Having it there was wrong and misleading.
I also updated the documentation to reflect this change and fixed the
wrong description of als_setting, now used for als_enabled.

Is returning -ENODEV only when writing to als_enabled the right thing
to do or should it be returned also when reading als_enabled?

Thanks,
Gabriele
