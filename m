Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755467Ab3AROnt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 09:43:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:31642 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750820Ab3AROns (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 09:43:48 -0500
Date: Fri, 18 Jan 2013 14:43:46 +0000
From: thornber@redhat.com
To: device-mapper development <dm-devel@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [dm-devel] Announcement: STEC EnhanceIO SSD caching software for
 Linux kernel
Message-ID: <20130118144345.GA3077@raspberrypi>
Mail-Followup-To: device-mapper development <dm-devel@redhat.com>,
	Mike Snitzer <snitzer@redhat.com>,
	LKML <linux-kernel@vger.kernel.org>
References: <C4B5704C6FEB5244B2A1BCC8CF83B86B07CE4D6F3C@MYMBX.MY.STEC-INC.AD>
 <CAMM=eLdgD8GKeK48SU2rfC49u3H4WRf9-xFxM4ymVPbKkx+mCw@mail.gmail.com>
 <C4B5704C6FEB5244B2A1BCC8CF83B86B07CE4D70CE@MYMBX.MY.STEC-INC.AD>
 <20130116104546.GA3869@raspberrypi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130116104546.GA3869@raspberrypi>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 16, 2013 at 10:45:47AM +0000, thornber@redhat.com wrote:
> I'll create a branch in my github tree with all three caches in.  So
> it's easy to build a kernel with them.  (Mike's already combined
> dm-cache and bcache and done some preliminary testing).

git://github.com/jthornber/linux-2.6.git

branch 'all-caches'

I managed to reproduce the hang with bcache that Mike described
before.  However I can see that it was running the test more quickly
than eio at this point.

- Joe
