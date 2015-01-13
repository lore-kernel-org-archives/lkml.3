Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753230AbbAMF7U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 00:59:20 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39978 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751058AbbAMF7O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 00:59:14 -0500
Date: Mon, 12 Jan 2015 19:34:45 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: Forest Bond <forest@alittletooquiet.net>, devel@driverdev.osuosl.org,
        Guillaume Clement <gclement@baobob.org>,
        Malcolm Priestley <tvboxspy@gmail.com>, linux-kernel@vger.kernel.org,
        Joe Perches <joe@perches.com>
Subject: Re: [PATCH] staging: vt6655: mac.c:  Remove unused function
Message-ID: <20150113033445.GA31207@kroah.com>
References: <1417989764-18481-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417989764-18481-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 07, 2014 at 11:02:44PM +0100, Rickard Strandqvist wrote:
> Remove the function MACbCompareContext() that is not used anywhere.
> 
> This was partially found by using a static code analysis program called cppcheck.
> 
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
> ---
>  drivers/staging/vt6655/mac.c |   42 ------------------------------------------
>  drivers/staging/vt6655/mac.h |    1 -
>  2 files changed, 43 deletions(-)

This doesn't apply to any tree that I can determine :(
