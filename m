Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751710Ab3FVTnd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Jun 2013 15:43:33 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:47083 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751366Ab3FVTnb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Jun 2013 15:43:31 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Joe Perches <joe@perches.com>
Cc: Shuah Khan <shuah.kh@samsung.com>, pavel@ucw.cz, len.brown@intel.com,
        gregkh@linuxfoundation.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, shuahkhan@gmail.com
Subject: Re: [PATCHv v3] power: Include additional information in pm_print_times
Date: Sat, 22 Jun 2013 21:52:52 +0200
Message-ID: <2732229.sfB5fHUFTc@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0-rc5+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1371868042.2086.0.camel@joe-AO722>
References: <1371497795-20084-1-git-send-email-shuah.kh@samsung.com> <2534796.mOHH0DCD2A@vostro.rjw.lan> <1371868042.2086.0.camel@joe-AO722>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, June 21, 2013 07:27:22 PM Joe Perches wrote:
> On Sat, 2013-06-22 at 02:24 +0200, Rafael J. Wysocki wrote:
> > Namely, there are tools that use these messages to create suspend/resume time
> > charts and they will stop working after the proposed changes.
> 
> dmesg output isn't guaranteed to be stable.

So?

