Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754118AbaEAIlP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 04:41:15 -0400
Received: from mail-la0-f44.google.com ([209.85.215.44]:41012 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752140AbaEAIlK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 04:41:10 -0400
Date: Thu, 1 May 2014 10:40:45 +0200
From: Johan Hovold <jhovold@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "J. Bruce Fields" <bfields@fieldses.org>, Jeff Layton <jlayton@redhat.com>,
        Mark Lord <mlord@pobox.com>, Albert Fluegel <af@muc.de>,
        linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: [stable] linux-3.14 nfsd regression
Message-ID: <20140501084045.GA4766@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

I noticed that v3.14 broke my development system which relies on nfsroot
for embedded targets, but soon found Bruce's fix (which has now been in
Linus' tree for a while):

	082f31a2169b ("nfsd: revert v2 half of "nfsd: don't return high
		       mode bits")

The fix did not make it into v3.14.2 (and I didn't find it in your
stable queue), so I thought I'd send a reminder.

Thanks,
Johan
