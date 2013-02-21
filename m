Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755026Ab3BURgm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 12:36:42 -0500
Received: from mail-la0-f50.google.com ([209.85.215.50]:45863 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754493Ab3BURgk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 12:36:40 -0500
MIME-Version: 1.0
In-Reply-To: <20130221033309.CFBB0660BDB@gitolite.kernel.org>
References: <20130221033309.CFBB0660BDB@gitolite.kernel.org>
Date: Thu, 21 Feb 2013 10:36:38 -0700
Message-ID: <CAKocOONU=S7w2bDc1Hf+PqP=pjJ14sdKOVC4UZH7ymx6h+vcyA@mail.gmail.com>
Subject: Re: ixgbe: fix possible data corruption in read_i2c_byte
From: Shuah Khan <shuahkhan@gmail.com>
To: jeffrey.t.kirsher@intel.com, emil.s.tantilov@intel.com,
        phillip.j.schmitt@intel.com
Cc: linux-kernel@vger.kernel.org, Greg KH <gregkh@linuxfoundation.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 20, 2013 at 8:33 PM, Linux Kernel Mailing List
<linux-kernel@vger.kernel.org> wrote:
> Gitweb:     http://git.kernel.org/linus/;a=commit;h=d0310dc415a670ae2b2e27076b4685d988830479
> Commit:     d0310dc415a670ae2b2e27076b4685d988830479
> Parent:     4c696ca9fbabc5f94a3c6db7f009e73f0ef21831
> Author:     Emil Tantilov <emil.s.tantilov@intel.com>
> AuthorDate: Fri Jan 18 02:16:41 2013 +0000
> Committer:  Jeff Kirsher <jeffrey.t.kirsher@intel.com>
> CommitDate: Fri Feb 15 23:16:09 2013 -0800
>
>     ixgbe: fix possible data corruption in read_i2c_byte
>
>     This patch makes sure that the SW lock is released after all i2c
>     operations complete in the retry code path.
>
>     Signed-off-by: Emil Tantilov <emil.s.tantilov@intel.com>
>     Tested-by: Phil Schmitt <phillip.j.schmitt@intel.com>
>     Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>

Jeff,

Should this patch be considered for stable? This patch applied cleanly
to 3.7 and 3.4. I haven't done any testing yet.

-- Shuah
