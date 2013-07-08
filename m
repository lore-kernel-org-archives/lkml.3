Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753222Ab3GHU2F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 16:28:05 -0400
Received: from b.ns.miles-group.at ([95.130.255.144]:1660 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753141Ab3GHU2D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 16:28:03 -0400
Message-ID: <51DB20CB.9020706@nod.at>
Date: Mon, 08 Jul 2013 22:27:55 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Tristan Schmelcher <tschmelcher@google.com>
CC: jdike@addtoit.com, user-mode-linux-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv3] uml: Fix which_tmpdir failure when /dev/shm is a symlink,
 and in other edge cases
References: <51DB1EE5.5040108@google.com>
In-Reply-To: <51DB1EE5.5040108@google.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 08.07.2013 22:19, schrieb Tristan Schmelcher:
> From: Tristan Schmelcher <tschmelcher@google.com>
> 
> which_tmpdir did the wrong thing if /dev/shm was a symlink (e.g., to /run/shm),
> if there were multiple mounts on top of each other, if the mount(s) were
> obscured by a later mount, or if /dev/shm was a prefix of another mount point.
> This fixes these cases. Applies to 3.9.6.
> 
> Signed-off-by: Tristan Schmelcher <tschmelcher@google.com>

Is this just a resend or did your alter the patch you sent me already?
I'm about to send my UML patches to Linus tomorrow.

Thanks,
//richard
