Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753686AbbAMGAH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 01:00:07 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:40038 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753654AbbAMGAG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 01:00:06 -0500
Date: Mon, 12 Jan 2015 19:42:27 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: Forest Bond <forest@alittletooquiet.net>,
        Guillaume Clement <gclement@baobob.org>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: vt6655: srom.c:  Remove some unused functions
Message-ID: <20150113034227.GA16203@kroah.com>
References: <1419184983-11386-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1419184983-11386-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 21, 2014 at 07:03:03PM +0100, Rickard Strandqvist wrote:
> Removes some functions that are not used anywhere:
> SROMbAutoLoad() SROMvReadSubSysVenId() SROMvWriteEtherAddress()
> SROMvWriteAllContents() SROMbIsRegBitsOff() SROMbIsRegBitsOn()
> SROMvRegBitsOff() SROMvRegBitsOn()
> 
> This was partially found by using a static code analysis program called cppcheck.
> 
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
> ---
>  drivers/staging/vt6655/srom.c |  206 -----------------------------------------
>  drivers/staging/vt6655/srom.h |   11 ---
>  2 files changed, 217 deletions(-)

This doesn't apply at all to my tree :(
