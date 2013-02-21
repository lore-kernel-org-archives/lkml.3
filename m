Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755542Ab3BURm5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 12:42:57 -0500
Received: from mail-lb0-f174.google.com ([209.85.217.174]:57427 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753876Ab3BURmz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 12:42:55 -0500
MIME-Version: 1.0
In-Reply-To: <20130221033255.3778C660A7E@gitolite.kernel.org>
References: <20130221033255.3778C660A7E@gitolite.kernel.org>
Date: Thu, 21 Feb 2013 10:42:53 -0700
Message-ID: <CAKocOON0V3WGLPpdVAq_9+o9GT=kJ192wywsS_m_yNTMKcUTow@mail.gmail.com>
Subject: Re: ixgbe: fix potential null dereference
From: Shuah Khan <shuahkhan@gmail.com>
To: jeffrey.t.kirsher@intel.com, joshua.a.hay@intel.com,
        phillip.j.schmitt@intel.com
Cc: stable <stable@vger.kernel.org>, Greg KH <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 20, 2013 at 8:32 PM, Linux Kernel Mailing List
<linux-kernel@vger.kernel.org> wrote:
> Gitweb:     http://git.kernel.org/linus/;a=commit;h=f752be9c3de4fbb6a9b2c060f3794bd928a0ad7a
> Commit:     f752be9c3de4fbb6a9b2c060f3794bd928a0ad7a
> Parent:     07ce870bed2f631ad53a2c1a90db20b5f8126ab9
> Author:     Josh Hay <joshua.a.hay@intel.com>
> AuthorDate: Fri Jan 4 03:34:36 2013 +0000
> Committer:  Jeff Kirsher <jeffrey.t.kirsher@intel.com>
> CommitDate: Tue Feb 5 01:43:49 2013 -0800
>
>     ixgbe: fix potential null dereference
>
>     This patch adds a default case which goes to the next loop iteration
>     in the case where p is not set, preventing p from being dereferenced.
>
>     Signed-off-by: Josh Hay <joshua.a.hay@intel.com>
>     Tested-by: Phil Schmitt <phillip.j.schmitt@intel.com>
>     Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
> ---

Jeff/Josh,

Should this patch be considered for stable release 3.7 and 3.4. It
applied cleanly to both of these releases. I haven't tested it yet
though.

-- Shuah
