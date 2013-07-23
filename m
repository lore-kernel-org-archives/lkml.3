Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933783Ab3GWVjy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 17:39:54 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40771 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754713Ab3GWVjx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 17:39:53 -0400
Date: Tue, 23 Jul 2013 14:39:52 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: "Raphael S. Carvalho" <raphael.scarv@gmail.com>
Cc: William Hubbs <w.d.hubbs@gmail.com>,
        Chris Brannon <chris@the-brannons.com>,
        Kirk Reiser <kirk@braille.uwo.ca>,
        Samuel Thibault <samuel.thibault@ens-lyon.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Lijo Antony <lijo.kernel@gmail.com>, speakup@braille.uwo.ca,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] staging/speakup/kobjects.c: Code improvement.
Message-ID: <20130723213952.GA15052@kroah.com>
References: <1371866080-13752-1-git-send-email-raphael.scarv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1371866080-13752-1-git-send-email-raphael.scarv@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 21, 2013 at 10:54:40PM -0300, Raphael S. Carvalho wrote:
> Well, there is no need to use strcmp since we can make a test of similar
> semantic by using the var_id field of param.
> I moved the test into the VAR_NUM:VAR_TIME case since VAR_STRING will
> never be "voice".
> 
> spk_xlate isn't used anymore (in line 608), then there is no difference
> between using cp and buf in VAR_STRING case.
> Besides, buf is a const char and those changes remove one uneeded line.
> 
> I created the function spk_reset_default_value because it clarifies the
> code and allows code reusing.
> 
> Signed-off-by: Raphael S. Carvalho <raphael.scarv@gmail.com>
> Acked-by: Samuel Thibault <samuel.thibault@ens-lyon.org>
> ---
>  drivers/staging/speakup/kobjects.c |   73 +++++++++++++++++++----------------
>  1 files changed, 40 insertions(+), 33 deletions(-)

This patch no longer applies to my tree, can you please refresh it
against linux-next and resend, keeping Samuel's ack on it?

thanks,

greg k-h
