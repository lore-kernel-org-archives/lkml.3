Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752120AbaAPEvL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 23:51:11 -0500
Received: from SpacedOut.fries.net ([67.64.210.234]:45934 "EHLO
	SpacedOut.fries.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751046AbaAPEvJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 23:51:09 -0500
Date: Wed, 15 Jan 2014 22:51:01 -0600
From: David Fries <David@Fries.net>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: pull w1 updates to linux-next?
Message-ID: <20140116045100.GB29560@spacedout.fries.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Greylist: Sender passed SPF test, not delayed by milter-greylist-4.3.9 (SpacedOut.fries.net [127.0.0.1]); Wed, 15 Jan 2014 22:51:02 -0600 (CST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've not submitted to linux-next before, would you pull the one wire
changes to linux-next?  It has been posted and reviewed by one wire
maintainer Evgeniy Polyakov, and the 15 patch series was posted again
ready to go for GregKH to pick up.  This is my one wire tree not
maintainer, and once merged upstream won't be updated unless I have
another set of changes.

cd5f76716a37ebef3e8b771d672ba552a25dafd5
git://github.com/dfries/linux.git w1_rework

-- 
David Fries <david@fries.net>    PGP pub CB1EE8F0
http://fries.net/~david/
