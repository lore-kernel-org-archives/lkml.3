Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759749Ab3BZSgx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 13:36:53 -0500
Received: from mail.tpi.com ([70.99.223.143]:2442 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756521Ab3BZSgw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 13:36:52 -0500
Message-ID: <512D00BE.8090204@canonical.com>
Date: Tue, 26 Feb 2013 11:36:46 -0700
From: Tim Gardner <tim.gardner@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: mgreer@animalcreek.com
CC: herbert@gondor.hengli.com.au, dmitry.kasatkin@intel.com,
        linux-kernel@vger.kernel.org
Subject: crypto: omap-sham, omap-aes and dma_request_slave_channel_compat()
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Whats up with commits 0e87e73f4abe1ada69cf780fe2550c6361a1b53b and
b4b87a934c30fb91cbdd18ae028acdc361e1cf0f. As far as I can tell,
dma_request_slave_channel_compat() does not exist in 3.9 as of
52caa59ed335616c5254adff7911465a57ed9f14, nor does it exist in
linux-next as of Feb 26. Am I just being dense ?

Reverting those 2 commits at least allows the compile complete.

rtg
-- 
Tim Gardner tim.gardner@canonical.com
