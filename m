Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757833Ab3FTNkK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 09:40:10 -0400
Received: from b.ns.miles-group.at ([95.130.255.144]:1660 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757512Ab3FTNkJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 09:40:09 -0400
Message-ID: <51C3062F.6000304@nod.at>
Date: Thu, 20 Jun 2013 15:39:59 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Tristan Schmelcher <tschmelcher@google.com>
CC: jdike@addtoit.com,
        user-mode-linux-devel <user-mode-linux-devel@lists.sourceforge.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2] uml: Fix which_tmpdir failure when /dev/shm is a symlink,
 and in other edge cases
References: <51C21645.3050108@google.com> <CADNZ+wRMzCxeUr5nUU43TunCsdN4+S8wHkzAVYvQPsq9G0=PwQ@mail.gmail.com>
In-Reply-To: <CADNZ+wRMzCxeUr5nUU43TunCsdN4+S8wHkzAVYvQPsq9G0=PwQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 20.06.2013 15:36, schrieb Tristan Schmelcher:
> *sigh* found another bug. Gonna sit on the patch for a bit before
> sending v3, just in case I find more issues.

No need to hurry. :-)
As the patch is non-trivial it's 3.11 material anyway.

Thanks,
//richard


