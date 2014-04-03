Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753450AbaDCTUd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 15:20:33 -0400
Received: from imap.thunk.org ([74.207.234.97]:49667 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752828AbaDCTUc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 15:20:32 -0400
Date: Thu, 3 Apr 2014 15:20:21 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Tejun Heo <tj@kernel.org>
Cc: Thomas =?iso-8859-1?Q?B=E4chler?= <thomas@archlinux.org>,
        Dave Reisner <d@falconindy.com>, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, P@draigbrady.com,
        alexandre.f.demers@gmail.com
Subject: Re: Initramfs FSID altered in 3.14
Message-ID: <20140403192021.GB32323@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>, Tejun Heo <tj@kernel.org>,
	Thomas =?iso-8859-1?Q?B=E4chler?= <thomas@archlinux.org>,
	Dave Reisner <d@falconindy.com>, linux-kernel@vger.kernel.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, P@draigbrady.com,
	alexandre.f.demers@gmail.com
References: <20140403175744.GE585@rampage>
 <533DA4DE.40408@archlinux.org>
 <20140403191617.GB2472@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140403191617.GB2472@mtj.dyndns.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I agree with Tejun that we should fix it up, and not force
distributions to have to send out emergency releases of various
userspace utilities --- especially since the fix is so simple.

     	 	   	       	       		 - Ted
