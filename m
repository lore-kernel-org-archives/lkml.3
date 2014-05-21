Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753676AbaEUWNe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 18:13:34 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:37478 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753434AbaEUWNd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 18:13:33 -0400
Date: Thu, 22 May 2014 01:12:52 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: devel@driverdev.osuosl.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Josh Triplett <josh@joshtriplett.org>, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Manu Gupta <manugupt1@gmail.com>,
        Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH] staging: rtl8188eu: os_dep: usb_intf.c: Fix for possible
 null pointer dereference
Message-ID: <20140521221252.GG15585@mwanda>
References: <1400621477-7603-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
 <537BE4BB.4010308@lwfinger.net>
 <20140520235756.GA23550@cloud>
 <20140521072450.GT15585@mwanda>
 <CAFo99gZ6TUdJm7Vw7=XusOujTuNLC_CkNZHU3hgxG13GVUqgRw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFo99gZ6TUdJm7Vw7=XusOujTuNLC_CkNZHU3hgxG13GVUqgRw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 21, 2014 at 11:51:06PM +0200, Rickard Strandqvist wrote:
> Hi
> 
> Exactly as you say Dan, cppcheck has found that there is a null check
> at some point while the others in this case are missed. So I'm not for
> unnecessary checks.
> But we can instead agree that I make a patch that will remove all null
> checks padapter?

Yes.  On this function remove all the checks for padapter.

regards,
dan carpenter

