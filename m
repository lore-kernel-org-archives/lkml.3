Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756036AbaKTLWE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 06:22:04 -0500
Received: from mout.kundenserver.de ([212.227.126.131]:50140 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751132AbaKTLWA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 06:22:00 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v5 0/4] Correct vendor-prefix and document device isl29028
Date: Thu, 20 Nov 2014 12:21:43 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-35-generic; KDE/4.3.2; x86_64; ; )
Cc: Darshana Padmadas <darshanapadmadas@gmail.com>, devicetree@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org, opw-kernel@googlegroups.com
References: <1415467328-9745-1-git-send-email-darshanapadmadas@gmail.com>
In-Reply-To: <1415467328-9745-1-git-send-email-darshanapadmadas@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201411201221.43308.arnd@arndb.de>
X-Provags-ID: V02:K0:L66smwDxICSacyyZTTcOE2SEMSMMAvq8RaITSS9F6F6
 4oOseLx+VuqCazAhBrQ7L19Y0+mqbqAJRejwv+yIChxWjm5kLS
 GhMC75zjH+Bc+8Zm2ciQscw4/6J8c+QgYZxQb1RsaeS2yiBZ2H
 MzsnpdbhetNwrFqjW9CUNinAKeaWvlI8RXsec6QCIClAk4UBiY
 ByMfr/h1TJyrK9qAS8E6KUhJ/Xfqub/zh49bgXTDbUYY9huf2M
 164oz4cLm+A1pCG1Ux48gY0ajuPyELrN8dInjkTAT0EwKOxKuv
 KAtu/YSRxXxsitC30pF/j5J3h4+4RoNdWlL4T1rBCkEhyLHjDR
 wxlo8Or0Q8FuslG2X5n8WUgfMKK7FmO5t3qtbQn9W
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 08 November 2014, Darshana Padmadas wrote:
> Patchset documents correct and the deprecated vendor-prefix found by checkpatch
> warning and also documents information of device isl29028 for compatibility.
> Patchset also includes corrected vendor-prefix and device name in compatible
> property for files with checkpatch warning of undocumented string "isil,isl29028".
> 

Since nobody else has picked these up, I've put them into the arm-soc
tree in the next/dt branch now.

Thanks and sorry for the delay,

	Arnd
