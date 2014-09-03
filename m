Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756796AbaICVl7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 17:41:59 -0400
Received: from lists.s-osg.org ([54.187.51.154]:52780 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756285AbaICVl5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 17:41:57 -0400
Message-ID: <54078B22.5020200@osg.samsung.com>
Date: Wed, 03 Sep 2014 15:41:54 -0600
From: Shuah Khan <shuahkh@osg.samsung.com>
Organization: Samsung Open Source Group
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Pranith Kumar <bobby.prani@gmail.com>,
        David Herrmann <dh.herrmann@gmail.com>,
        Hugh Dickins <hughd@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "open list:KERNEL SELFTEST F..." <linux-api@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
CC: Shuah Khan <shuahkh@osg.samsung.com>
Subject: Re: [PATCH v3] memfd_test: Make it work on 32-bit systems
References: <1409754679-22667-1-git-send-email-bobby.prani@gmail.com>
In-Reply-To: <1409754679-22667-1-git-send-email-bobby.prani@gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/03/2014 08:31 AM, Pranith Kumar wrote:
> This test currently fails on 32-bit systems since we use u64 type to pass the
> flags to fcntl.
> 
> This commit changes this to use 'unsigned int' type for flags to fcntl making it
> work on 32-bit systems.
> 
> Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
> Reviewed-by: David Herrmann <dh.herrmann@gmail.com>
> ---

I will queue this up for 3.17-fixes. I am in the process of
setting up kselftest git for fixes.

thanks,
-- Shuah


-- 
Shuah Khan
Sr. Linux Kernel Developer
Samsung Research America (Silicon Valley)
shuahkh@osg.samsung.com | (970) 217-8978
