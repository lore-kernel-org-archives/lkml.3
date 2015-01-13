Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753763AbbAMGAe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 01:00:34 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:40045 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753660AbbAMGAH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 01:00:07 -0500
Date: Mon, 12 Jan 2015 19:43:29 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: Forest Bond <forest@alittletooquiet.net>, Joe Perches <joe@perches.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: vt6655: mib.c:  Remove some unused functions
Message-ID: <20150113034329.GA22444@kroah.com>
References: <1420132712-32285-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1420132712-32285-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 01, 2015 at 06:18:32PM +0100, Rickard Strandqvist wrote:
> Removes some functions that are not used anywhere:
> STAvClearAllCounter() STAvClear802_11Counter()
> STAvUpdateTDStatCounterEx() STAvUpdateRDStatCounterEx()
> 
> This was partially found by using a static code analysis program called cppcheck.
> 
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
> ---
>  drivers/staging/vt6655/mib.c |  113 ------------------------------------------
>  drivers/staging/vt6655/mib.h |   14 ------
>  2 files changed, 127 deletions(-)

Doesn't apply, what are you making these patches against?


