Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751639AbbAAVAP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jan 2015 16:00:15 -0500
Received: from linode.cmadams.net ([209.123.162.222]:52999 "EHLO
	linode.cmadams.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751242AbbAAVAO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jan 2015 16:00:14 -0500
X-Greylist: delayed 662 seconds by postgrey-1.27 at vger.kernel.org; Thu, 01 Jan 2015 16:00:14 EST
Date: Thu, 1 Jan 2015 14:49:07 -0600
From: Chris Adams <cmadams@cmadams.net>
To: linux-kernel@vger.kernel.org
Subject: Disappearing RFC3041 IPv6 privacy addresses
Message-ID: <20150101204907.GA16264@cmadams.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Starting (I believe) with kernel 3.17, I am seeing RFC3041 IPv6 privacy
addresses disappear while they are still in use.  I have been seeing
open SSH connections drop, and have finally seen one "dead" but not yet
closed.  At that point "ss -t" shows an ESTAB socket with a local
address that is no longer listed by "ip -6 addr list br1".

This is on a Fedora 20 system, currently running the Fedora
3.17.7-200.fc20.x86_64 kernel.  I don't know if it matters, but my
network setup is a router running OpenWRT and just IPv6 RAs and SLAAC
(DHCPv6 disabled).
-- 
Chris Adams <cmadams@cmadams.net>
