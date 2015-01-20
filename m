Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752114AbbATHy4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 02:54:56 -0500
Received: from mail-pa0-f53.google.com ([209.85.220.53]:59207 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751938AbbATHyx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 02:54:53 -0500
Date: Mon, 19 Jan 2015 23:54:48 -0800
From: Tristan Lelong <tristan@lelong.xyz>
To: Greg KH <gregkh@linuxfoundation.org>
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
Message-ID: <20150120075448.GA4355@lenderer>
References: <1417910602-20953-1-git-send-email-tristan@lelong.xyz>
 <20150117232827.GA17007@kroah.com>
 <20150118064144.GA7158@lenderer>
 <20150118070222.GA10794@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150118070222.GA10794@kroah.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg,

On Sun, Jan 18, 2015 at 04:02:22PM +0900, Greg KH wrote:
> On Sat, Jan 17, 2015 at 10:41:44PM -0800, Tristan Lelong wrote:
> > Hi Greg,
> > 
> > On Sat, Jan 17, 2015 at 03:28:27PM -0800, Greg KH wrote:
> > > 
> > > I took your v2 version, please send me the difference as this is a
> > > mess...
> > 
> > Not sure I understand what you meant here. 
> > Do you want me to submit a new patch that contains only the differences between v2 and v3?
> 
> Yes please.  Make it against the tree you got the email saying when your
> v2 patch was accepted.
> 

Just for reference, I submitted this patch as a new patch "[PATCH] staging: lustre: remove kmalloc from fld_proc_hash_seq_write"
I figured out it might trigger some more comments, and didn't want to add to the confusion.
Let me know if this is the right way, or if you would prefer an answer to email with the updated patch.

Regards
