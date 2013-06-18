Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753774Ab3FRB7V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 21:59:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42180 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751549Ab3FRB7U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 21:59:20 -0400
Date: Mon, 17 Jun 2013 21:58:21 -0400
From: Dave Jones <davej@redhat.com>
To: David Airlie <airlied@redhat.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, bskeggs@redhat.com,
        dri-devel@lists.freedesktop.org
Subject: Re: [3.10rc6] /proc/dri/0/vma broken on nouveau.
Message-ID: <20130618015821.GA8346@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	David Airlie <airlied@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>, bskeggs@redhat.com,
	dri-devel@lists.freedesktop.org
References: <20130618013602.GC2200@redhat.com>
 <1257782958.19234314.1371520167209.JavaMail.root@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1257782958.19234314.1371520167209.JavaMail.root@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 17, 2013 at 09:49:27PM -0400, David Airlie wrote:
 > 
 > > Reading /proc/dri/0/vma causes bad things to happen on a box with nouveau
 > > loaded.
 > > (Note, no X running on that box)
 > > 
 > > Trace below shows trinity, but I can reproduce it with just cat
 > > /proc/dri/0/vma
 > 
 > How about this, lets just rip it all out.

That's one way to deal with it :)
If no programs use it, then yeah, sure, why not.

	Dave
