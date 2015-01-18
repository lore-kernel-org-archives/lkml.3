Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752166AbbARHCp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2015 02:02:45 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58762 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751611AbbARHCd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2015 02:02:33 -0500
Date: Sun, 18 Jan 2015 16:02:22 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: Tristan Lelong <tristan@lelong.xyz>
Cc: oleg.drokin@intel.com, andreas.dilger@intel.com, askb23@gmail.com,
        john.hammond@intel.com, gdonald@gmail.com, anhlq2110@gmail.com,
        fabio.falzoi84@gmail.com, oort10@gmail.com, agimenez@sysvalve.es,
        rupran@einserver.de, surya.seetharaman9@gmail.com,
        Julia.Lawall@lip6.fr, joe@perches.com, a.terekhov@gmail.com,
        liang.zhen@intel.com, vthakkar1994@gmail.com, amk@cray.com,
        srikrishanmalik@gmail.com, rd@radekdostal.com, bergwolf@gmail.com,
        dan.carpenter@oracle.com, paul.gortmaker@windriver.com,
        tapaswenipathak@gmail.com, email@christophjaeger.info,
        uja.ornl@gmail.com, brilliantov@inbox.ru, dmitry.eremin@intel.com,
        HPDD-discuss@ml01.01.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] staging: lustre: fix sparse warning on LPROC_SEQ_FOPS
 macros
Message-ID: <20150118070222.GA10794@kroah.com>
References: <1417910602-20953-1-git-send-email-tristan@lelong.xyz>
 <20150117232827.GA17007@kroah.com>
 <20150118064144.GA7158@lenderer>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150118064144.GA7158@lenderer>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 17, 2015 at 10:41:44PM -0800, Tristan Lelong wrote:
> Hi Greg,
> 
> On Sat, Jan 17, 2015 at 03:28:27PM -0800, Greg KH wrote:
> > 
> > I took your v2 version, please send me the difference as this is a
> > mess...
> 
> Not sure I understand what you meant here. 
> Do you want me to submit a new patch that contains only the differences between v2 and v3?

Yes please.  Make it against the tree you got the email saying when your
v2 patch was accepted.

thanks,

greg k-h
