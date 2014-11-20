Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757629AbaKTV6o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 16:58:44 -0500
Received: from lists.s-osg.org ([54.187.51.154]:52870 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757574AbaKTV6n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 16:58:43 -0500
Message-ID: <546E640F.1090006@osg.samsung.com>
Date: Thu, 20 Nov 2014 14:58:39 -0700
From: Shuah Khan <shuahkh@osg.samsung.com>
Organization: Samsung Open Source Group
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Tim Bird <tim.bird@sonymobile.com>, linux-api@vger.kernel.org
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-embedded@vger.kernel.org" <linux-embedded@vger.kernel.org>,
        Shuah Khan <shuahkh@osg.samsung.com>
Subject: Re: [PATCH v2] selftest: size: Add size test for Linux kernel
References: <546D084D.20002@sonymobile.com> <546D321F.2080405@sonymobile.com>
In-Reply-To: <546D321F.2080405@sonymobile.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/19/2014 05:13 PM, Tim Bird wrote:
> 
> This test shows the amount of memory used by the system.
> Note that this is dependent on the user-space that is loaded
> when this program runs.  Optimally, this program would be
> run as the init program itself.
> 
> The program is optimized for size itself, to avoid conflating
> its own execution with that of the system software.
> The code is compiled statically, with no stdlibs. On my x86_64 system,
> this results in a statically linked binary of less than 5K.
> 
> Changes from v1:
>   - use more correct Copyright string in get_size.c
> 
> Signed-off-by: Tim Bird <tim.bird@sonymobile.com>
> ---
>  tools/testing/selftests/Makefile        |   1 +
>  tools/testing/selftests/size/Makefile   |  21 +++++++
>  tools/testing/selftests/size/get_size.c | 105 ++++++++++++++++++++++++++++++++
>  3 files changed, 127 insertions(+)
>  create mode 100644 tools/testing/selftests/size/Makefile
>  create mode 100644 tools/testing/selftests/size/get_size.c

Tim,

The test looks good, but you are missing .gitignore file.
Please add a .gitignore for the binary that gets generated to
avoid git status including the binary it in its output.

thanks,
-- Shuah


-- 
Shuah Khan
Sr. Linux Kernel Developer
Samsung Research America (Silicon Valley)
shuahkh@osg.samsung.com | (970) 217-8978
