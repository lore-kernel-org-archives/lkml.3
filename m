Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753614Ab3LTTuT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 14:50:19 -0500
Received: from mx1.redhat.com ([209.132.183.28]:12243 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751231Ab3LTTuR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 14:50:17 -0500
Date: Fri, 20 Dec 2013 14:50:10 -0500
From: Dave Jones <davej@redhat.com>
To: trinity@vger.kernel.org
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Trinity 1.3.
Message-ID: <20131220195010.GA10605@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>, trinity@vger.kernel.org,
	Linux Kernel <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I just tagged and pushed out a tarball for 1.3, because it's been six months since
the last one, and the recent work on fuzzing mmaps seems to have reached a good
place to stop before I move onto the next set of changes.
[read as: so people can use 1.3 to continue breaking the VM while I potentially
 break things in trinity for a while]

Ideas for further improvements in this, or other areas always welcomed.

Tarball: http://codemonkey.org.uk/projects/trinity/trinity-1.3.tgz
git: git://git.codemonkey.org.uk/trinity

thanks,

	Dave

