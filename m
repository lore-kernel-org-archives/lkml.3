Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752578Ab3EHHna (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 03:43:30 -0400
Received: from lake.fysh.org ([81.94.195.195]:42827 "EHLO lake.fysh.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751863Ab3EHHn3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 03:43:29 -0400
X-Greylist: delayed 1240 seconds by postgrey-1.27 at vger.kernel.org; Wed, 08 May 2013 03:43:28 EDT
Date: Wed, 8 May 2013 08:22:45 +0100
From: Athanasius <link@miggy.org>
To: Greg KH <gregkh@linuxfoundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Linux 3.9.1
Message-ID: <20130508072245.GB4169@fysh.org>
Mail-Followup-To: Greg KH <gregkh@linuxfoundation.org>,
	linux-kernel <linux-kernel@vger.kernel.org>
References: <20130508041010.GA17374@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130508041010.GA17374@kroah.com>
X-gpg-fingerprint: E218CE1D
X-gpg-key: http://www.fysh.org/~athan/gpg-key
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 07, 2013 at 09:10:10PM -0700, Greg KH wrote:
> I'm announcing the release of the 3.9.1 kernel.
> 
> All users of the 3.9 kernel series must upgrade.
> 
> The updated 3.9.y git tree can be found at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-3.9.y

  Usually I can:

	git pull git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git master

which means not having to update scripts/commandline history on each
major verison change, but this time I did indeed need to:

	git pull git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-3.9.y

is this an intended change, or did you do something like forgetting to
merge into master on linux-stable ?

-- 
- Athanasius = Athanasius(at)miggy.org / http://www.miggy.org/
                  Finger athan(at)fysh.org for PGP key
	   "And it's me who is my enemy. Me who beats me up.
Me who makes the monsters. Me who strips my confidence." Paula Cole - ME
