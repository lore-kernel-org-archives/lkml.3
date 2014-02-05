Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752008AbaBETwl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 14:52:41 -0500
Received: from imap.thunk.org ([74.207.234.97]:54463 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751107AbaBETwi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 14:52:38 -0500
Date: Wed, 5 Feb 2014 14:52:36 -0500
From: "Theodore Ts'o" <tytso@mit.edu>
To: Gene Heskett <gheskett@wdtv.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: possible viri in tarballs?
Message-ID: <20140205195236.GM11667@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Gene Heskett <gheskett@wdtv.com>, linux-kernel@vger.kernel.org
References: <201402050915.34607.gheskett@wdtv.com>
 <201402051324.59495.gheskett@wdtv.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201402051324.59495.gheskett@wdtv.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 05, 2014 at 01:24:59PM -0500, Gene Heskett wrote:
> >/home/gene/src/linux-3.2.40/Documentation/usb/gadget_multi.txt:
> >MBL_400944.UNOFFICIAL FOUND
> 
> You will see more history.
> 
> So that file needs sanitized.  I was under the impression that a file with 
> the .txt extension was supposed to be pure ascii text, but its loaded to 
> the gills with some sort of markup crap.  And I have at least 20 copies of 
> it.

Huh?   There are lines with 

* Overview

...

** Linux host drivers

...

in that file, sure.  But I'd hardly call that "loaded to the gills
with markup crap".

If the file was had any amount of XML or XHTML2, that would be markup
crap.  But some Twiki style ascii markup is hardly a problem -- it
looks just fine when viewed in a text reader.

      	   	     	       	 - Ted
