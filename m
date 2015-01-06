Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756120AbbAFUC3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 15:02:29 -0500
Received: from lists.s-osg.org ([54.187.51.154]:42893 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755844AbbAFUC1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 15:02:27 -0500
Message-ID: <54AC3F48.5010803@osg.samsung.com>
Date: Tue, 06 Jan 2015 13:02:16 -0700
From: Shuah Khan <shuahkh@osg.samsung.com>
Organization: Samsung Open Source Group
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: David Drysdale <drysdale@google.com>, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
CC: Andreas Schwab <schwab@linux-m68k.org>,
        Andrew Morton <akpm@linux-foundation.org>, linux-m68k@vger.kernel.org,
        linux-api@vger.kernel.org
Subject: Re: [PATCHv2] selftests/exec: allow shell return code of 126
References: <1420532636-7317-1-git-send-email-drysdale@google.com>
In-Reply-To: <1420532636-7317-1-git-send-email-drysdale@google.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/06/2015 01:23 AM, David Drysdale wrote:
> When the shell fails to invoke a script because its path name
> is too long (ENAMETOOLONG), most shells return 127 to indicate
> command not found.  However, some systems report 126 (which POSIX
> suggests should indicate a non-executable file) for this case,
> so allow that too.
> 
> Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
> Signed-off-by: David Drysdale <drysdale@google.com>
> Tested-by: Geert Uytterhoeven <geert@linux-m68k.org>
> ---
>  tools/testing/selftests/exec/execveat.c | 19 +++++++++++++------
>  1 file changed, 13 insertions(+), 6 deletions(-)

Thanks. Applied to kernel/git/shuah/linux-kselftest fixes branch

-- Shuah

-- 
Shuah Khan
Sr. Linux Kernel Developer
Open Source Innovation Group
Samsung Research America (Silicon Valley)
shuahkh@osg.samsung.com | (970) 217-8978
