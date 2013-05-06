Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753579Ab3EFNl3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 09:41:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9116 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753405Ab3EFNl2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 09:41:28 -0400
Date: Mon, 6 May 2013 09:41:23 -0400
From: Dave Jones <davej@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, mst@redhat.com
Subject: Re: Add missing module license tag to vring helpers.
Message-ID: <20130506134123.GA8092@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Rusty Russell <rusty@rustcorp.com.au>,
	Linux Kernel <linux-kernel@vger.kernel.org>, mst@redhat.com
References: <20130503204009.GA29376@redhat.com>
 <87bo8opnk8.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87bo8opnk8.fsf@rustcorp.com.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 06, 2013 at 05:06:23PM +0930, Rusty Russell wrote:
 > Dave Jones <davej@redhat.com> writes:
 > > [  624.286653] vringh: module license 'unspecified' taints kernel.
 > >
 > > Signed-off-by: Dave Jones <davej@redhat.com>
 > 
 > Thanks!  This is exactly right.
 > 
 > But note that the default license tag for otherwise-unlabelled modules
 > would be "GPLv2".  "GPL" means v2 or later (which is what I want, but
 > it's not the kernel default).

It would be good if we could somehow catch missing tags at build-time
rather than have to run around fixing them after they get merged.

	Dave

