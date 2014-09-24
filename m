Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754369AbaIXRUy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 13:20:54 -0400
Received: from lists.s-osg.org ([54.187.51.154]:37510 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753917AbaIXRUv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 13:20:51 -0400
Message-ID: <5422FD71.3020603@osg.samsung.com>
Date: Wed, 24 Sep 2014 11:20:49 -0600
From: Shuah Khan <shuahkh@osg.samsung.com>
Organization: Samsung Open Source Group
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Peter Feiner <pfeiner@google.com>
CC: linux-api@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Herrmann <dh.herrmann@gmail.com>,
        Greg Thelen <gthelen@google.com>, Hugh Dickens <hughd@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Shuah Khan <shuahkh@osg.samsung.com>
Subject: Re: [PATCH v2 2/3] tools: adding clean target to user selftest
References: <1411499027-17801-1-git-send-email-pfeiner@google.com> <1411502120-28219-1-git-send-email-pfeiner@google.com> <1411502120-28219-3-git-send-email-pfeiner@google.com>
In-Reply-To: <1411502120-28219-3-git-send-email-pfeiner@google.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/23/2014 01:55 PM, Peter Feiner wrote:
> Gets rid of this error when running 'make clean' in the selftests
> directory:
> 
> make[1]: Entering directory `.../tools/testing/selftests/user'
> make[1]: *** No rule to make target `clean'.  Stop.
> 

Signed-off is missing. Please make sure patches have
your Signed-off

-- Shuah

-- 
Shuah Khan
Sr. Linux Kernel Developer
Samsung Research America (Silicon Valley)
shuahkh@osg.samsung.com | (970) 217-8978
