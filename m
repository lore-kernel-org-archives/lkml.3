Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751816AbaK0Ntp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 08:49:45 -0500
Received: from wolff.to ([98.103.208.27]:58691 "HELO wolff.to"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751019AbaK0Nto (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 08:49:44 -0500
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Thu, 27 Nov 2014 08:49:43 EST
Date: Thu, 27 Nov 2014 07:37:54 -0600
From: Bruno Wolff III <bruno@wolff.to>
To: Phillip Lougher <phillip@squashfs.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        texstar@gmail.com, martin@mvath.de, guanx.bac@gmail.com,
        dave@vasilevsky.ca, szycha@gmail.com, blyons@students.naropa.edu,
        tokiclover@gmail.com, afm404@gmail.com, hugochevrain@gmail.com
Subject: Re: [PATCH 0/2] Squashfs: add LZ4 compression
Message-ID: <20141127133754.GA12750@wolff.to>
References: <1417075250-6502-1-git-send-email-phillip@squashfs.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <1417075250-6502-1-git-send-email-phillip@squashfs.org.uk>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 27, 2014 at 08:00:47 +0000,
  Phillip Lougher <phillip@squashfs.org.uk> wrote:
>
>My intention is to submit them in the next kernel merge window.
>If you want LZ4 support in Squashfs now is a good time to publically
>support the inclusion of these patches.

Fedora has been supporting LZ4 functionallity in mksquashfs and unsquashfs 
for about 6 months (in F19+), but the Fedora kernel team won't add support 
in the kernel until LZ4 support is accepted for the upstream kernel.
