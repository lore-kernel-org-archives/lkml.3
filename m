Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754751AbaB0Djs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 22:39:48 -0500
Received: from mx1.redhat.com ([209.132.183.28]:6813 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754475AbaB0Djr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 22:39:47 -0500
Date: Wed, 26 Feb 2014 22:15:08 -0500
From: Dave Jones <davej@redhat.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: The sheer number of sparse warnings in the kernel
Message-ID: <20140227031508.GA8950@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Greg KH <gregkh@linuxfoundation.org>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <530E6F76.1070605@zytor.com>
 <20140226232859.GA9213@kroah.com>
 <530E82B2.3040305@zytor.com>
 <20140227013424.GA9991@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140227013424.GA9991@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 26, 2014 at 05:34:24PM -0800, Greg KH wrote:

 > Yes, for some areas of the kernel it will take some work, but for
 > others, sparse works really well.  As an example, building all of
 > drivers/usb/* with sparse only brings up 2 issues, both of which should
 > probably be fixed (or annotated properly in the case of the locking
 > warning.)

Hm. I see 102 in drivers/usb. Mostly in gadget. 
http://paste.fedoraproject.org/80787/39347077/raw/

(Note that some of those are duplicates, which would be nice if sparse
would be quieter about)

	Dave

