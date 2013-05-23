Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758588Ab3EWRPj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 13:15:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36189 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758108Ab3EWRPh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 13:15:37 -0400
Date: Thu, 23 May 2013 13:15:30 -0400
From: Dave Jones <davej@redhat.com>
To: Ben Minerds <puzzleduck@gmail.com>
Cc: greg@kroah.com, rob@landley.net, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/8] Documentation: Adding "The Perfect Patch" by Andrew
 Morton
Message-ID: <20130523171530.GK16419@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Ben Minerds <puzzleduck@gmail.com>, greg@kroah.com, rob@landley.net,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
References: <cover.1369312746.git.PuZZleDucK@gmail.com>
 <5114385ce1897015ad96f59f0fd46014d5f07786.1369312746.git.PuZZleDucK@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5114385ce1897015ad96f59f0fd46014d5f07786.1369312746.git.PuZZleDucK@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 23, 2013 at 10:49:53PM +1000, Ben Minerds wrote:
 > +- Don't bother mentioning what version of the kernel the patch applies to
 > +  ("applies to 2.6.8-rc1").  This is not interesting information - once the
 > +  patch is in bitkeeper, of _course_ it applied, and it'll probably be merged
 > +  into a later kernel than the one which you wrote it for.
 > +
 > +- Do not refer to earlier patches when changelogging a new version of a
 > +  patch.  It's not very useful to have a bitkeeper changelog which says "OK,
 > +  this fixes the things you mentioned yesterday".  Each iteration of the patch
 > +  should contain a standalone changelog.  This implies that you need a patch
 > +  management system which maintains changelogs.  See below.

s/bitkeeper/git/

 > +- Make sure that your patches apply to the latest version of the kernel
 > +  tree.  Either straight from bitkeeper or from
 > +  ftp://ftp.kernel.org/pub/linux/kernel/v2.6/snapshots/

ditto. (Also, update url)

	Dave

