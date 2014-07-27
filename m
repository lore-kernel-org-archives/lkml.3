Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752637AbaG0Sog (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2014 14:44:36 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40263 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752579AbaG0Sof (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2014 14:44:35 -0400
Date: Sun, 27 Jul 2014 11:44:34 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Monam Agarwal <monamagarwal123@gmail.com>
Subject: Re: [PATCH] staging: ced1401: userspace: use1401.c: Cleaning up
 missing null-terminate in conjunction with strncpy
Message-ID: <20140727184434.GA29496@kroah.com>
References: <1406416225-8795-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406416225-8795-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 27, 2014 at 01:10:25AM +0200, Rickard Strandqvist wrote:
> Replacing strncpy with strlcpy to avoid strings that lacks null terminate.
> And replacing strncat with strlcat because of incorrect use.
> 
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
> ---
>  drivers/staging/ced1401/userspace/use1401.c |   12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)

This file is no longer in my tree :(
