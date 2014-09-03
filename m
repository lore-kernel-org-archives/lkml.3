Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755642AbaICTAu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 15:00:50 -0400
Received: from s3.sipsolutions.net ([5.9.151.49]:34391 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753242AbaICTAt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 15:00:49 -0400
Message-ID: <1409770842.911.18.camel@jlt4.sipsolutions.net>
Subject: Re: [RFC] firmware coredump: add new firmware coredump class
From: Johannes Berg <johannes@sipsolutions.net>
To: Seth Forshee <seth.forshee@canonical.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, Daniel Vetter <daniel.vetter@ffwll.ch>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>, luca@coelho.fi,
        kvalo@adurom.com
Date: Wed, 03 Sep 2014 21:00:42 +0200
In-Reply-To: <20140903143814.GA37365@ubuntu-hedt> (sfid-20140903_163820_105145_84ED4B2A)
References: <1409742945-3933-1-git-send-email-johannes@sipsolutions.net>
	 <20140903143814.GA37365@ubuntu-hedt> (sfid-20140903_163820_105145_84ED4B2A)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.2-1+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-09-03 at 09:38 -0500, Seth Forshee wrote:

> Overall I think this looks pretty sensible. The thing that worries me
> though is firmware which might crash repeatedly in a short period of
> time, resulting in a proliferation of coredumps and eating up all
> available RAM. How about a limit of one active coredump per device or
> something similar?

Oh, right, I completely forgot about that. Not sure what context I can
iterate the class device list, but worst case I have to add another
list.

We likely want to store the first dump then, I suppose?

johannes

