Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757867Ab3GWPSP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 11:18:15 -0400
Received: from rrcs-98-103-208-26.central.biz.rr.com ([98.103.208.26]:60936
	"HELO wolff.to" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with SMTP id S1757616Ab3GWPSO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 11:18:14 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Tue, 23 Jul 2013 11:18:14 EDT
Date: Tue, 23 Jul 2013 10:10:09 -0500
From: Bruno Wolff III <bruno@wolff.to>
To: Phillip Lougher <phillip@squashfs.org.uk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] Squashfs: add LZ4 compression
Message-ID: <20130723151009.GA5971@wolff.to>
References: <1374459663-15363-1-git-send-email-phillip@squashfs.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <1374459663-15363-1-git-send-email-phillip@squashfs.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 22, 2013 at 03:21:01 +0100,
   Phillip Lougher <phillip@squashfs.org.uk> wrote:
>Hi
>
>Now that LZ4 compression support is in 3.11-rc1, I have written the
>following two patches for Squashfs to use it.

If this gets accepted are you going to move the LZ4 changes to squashfs-tools  
into the stable branch? I'd like to make LZ4 work in mksquashfs in at least 
rawhide once LZ4 is usable for squashfs file systems in the kernel. So I 
was wondering whether to expect this to appear in stable shortly or to expect 
to start doing builds using the master branch.
