Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755340Ab3ARO6d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 09:58:33 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:59550 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751866Ab3ARO6c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 09:58:32 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Vineet Gupta <Vineet.Gupta1@synopsys.com>
Subject: Re: [PATCH v2 63/76] ARC: Hostlink Pseudo-Driver for Metaware Debugger
Date: Fri, 18 Jan 2013 14:58:26 +0000
User-Agent: KMail/1.12.2 (Linux/3.7.0-7-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1358511930-7424-1-git-send-email-vgupta@synopsys.com> <1358511930-7424-64-git-send-email-vgupta@synopsys.com>
In-Reply-To: <1358511930-7424-64-git-send-email-vgupta@synopsys.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201301181458.26891.arnd@arndb.de>
X-Provags-ID: V02:K0:V7xE7WnpDHjms6mZopy+J4scwINFK+lFh4F/ixXnx20
 5VeNHMMbe5ASJP63PMmdIwQEFwQhQiZy5b22Hr/UxdQE5bjBy/
 Jpw4OgDZcF1gAmW0WPiYjy+Tq32QDAddONblxeS2SkO61I/1Jp
 Nh6M10/Clq3ucuDmaizpehX/w7hv8vX65z9KVJmp+tyHcsA0lY
 7n7vzJT4FBSDHyeGN5x05O4Mwq1aTT0RwglqfcEu66dhVQd6hy
 DgJ+mqYhqZsbzxuDo56yW3lecoGBOqfrTxHdF26OFAQe+VGWWj
 cLiv+Fi43OhTEGSvAykgXZ96gSBusdAOHdRwIFomm1ZXfUrXg4
 Zx8K2M5nuDmgj+Ei8L2s=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 18 January 2013, Vineet Gupta wrote:
> +static int arc_hl_nr_devs = 1;

This seems to be read-only and hardcoded to 1. If this is true, you could
simplify the driver significantly by just using misc_register, rather
than registering your own major device number.

	Arnd
