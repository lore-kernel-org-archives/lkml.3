Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752628AbaLGQmR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2014 11:42:17 -0500
Received: from plane.gmane.org ([80.91.229.3]:49294 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751052AbaLGQmP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2014 11:42:15 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Jindrich Makovicka <makovick@gmail.com>
Subject: Re: [PATCH 3.17 000/122] 3.17.5-stable review
Date: Sun, 7 Dec 2014 16:42:00 +0000 (UTC)
Message-ID: <m6200o$b13$1@ger.gmane.org>
References: <20141205223305.514276242@linuxfoundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: ip-62-245-126-51.net.upcbroadband.cz
User-Agent: Pan/0.139 (Sexual Chocolate; GIT bf56508
 git://git.gnome.org/pan2)
Cc: stable@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, 05 Dec 2014 14:42:54 -0800, Greg Kroah-Hartman wrote:

> This is the start of the stable review cycle for the 3.17.5 release.
> There are 122 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

I had to revert "netfilter: conntrack: fix race in __nf_conntrack_confirm 
against get_next_corpse" to be able to boot, getting a kernel panic 
otherwise:

http://goo.gl/q86SWy

It happens in various stages, but seems to be pretty consistently 
reproducible. This is a desktop running shorewall, with some nfqueue-
based IP filtering added.

Regards,
-- 
Jindrich Makovicka

