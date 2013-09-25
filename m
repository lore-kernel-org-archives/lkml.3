Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755921Ab3IYO3J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 10:29:09 -0400
Received: from www17.your-server.de ([213.133.104.17]:36549 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754886Ab3IYO3H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 10:29:07 -0400
Message-ID: <1380119333.7453.4.camel@localhost.localdomain>
Subject: Re: Copy on write hard links?
From: Thomas Meyer <thomas@m3y3r.de>
To: Rob Landley <rob@landley.net>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 25 Sep 2013 16:28:53 +0200
In-Reply-To: <1380117572.1974.81@driftwood>
References: <0EF3994A-6BC7-4FC7-AD2D-B4BE087EBFCA@m3y3r.de>
	 <1380117572.1974.81@driftwood>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5 (3.8.5-2.fc19) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, den 25.09.2013, 08:59 -0500 schrieb Rob Landley:
> On 09/24/2013 01:36:56 PM, Thomas Meyer wrote:
> > Hi,
> > 
> > Is there such a thing?
> 
> In the kernel's vfs layer? 

Yes, that would be a nice feature!

> No, although some filesystems (ala btrfs) do  
> things like that with snapshots.
> 
> In userspace? Breaking hardlinks when updating a file is fairly normal,  
> that's why they distinguish between "truncate and rewrite" (preserve  
> hardlinks) and "write new file and rename over old file" (break  
> hardlinks, avoiding the more obvious race conditions).

so every user space application needs to implement that for itself?
I wonder how hard it would be to implement this on vfs layer? linkat()
with a new flag as api or something like that.

> 
> Rob


