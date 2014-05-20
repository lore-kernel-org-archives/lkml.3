Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750923AbaETX4H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 19:56:07 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:18265 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750721AbaETX4G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 19:56:06 -0400
Date: Wed, 21 May 2014 02:55:39 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Larry Finger <Larry.Finger@lwfinger.net>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Josh Triplett <josh@joshtriplett.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Manu Gupta <manugupt1@gmail.com>
Subject: Re: [PATCH] staging: rtl8188eu: os_dep: usb_intf.c: Fix for possible
 null pointer dereference
Message-ID: <20140520235539.GS15585@mwanda>
References: <1400621477-7603-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1400621477-7603-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 20, 2014 at 11:31:16PM +0200, Rickard Strandqvist wrote:
> +	if (!padapter)  {
> +		goto error_exit;
> +	}

Btw, I forgot to mention this before but please run your patches through
scripts/checkpatch.pl.

regards,
dan carpenter

