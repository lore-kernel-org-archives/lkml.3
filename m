Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756450AbaIWTlA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 15:41:00 -0400
Received: from lists.s-osg.org ([54.187.51.154]:37250 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753292AbaIWTk7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 15:40:59 -0400
Message-ID: <5421CCC9.7080701@osg.samsung.com>
Date: Tue, 23 Sep 2014 13:40:57 -0600
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
Subject: Re: [PATCH 2/3] tools: fix warning in memfd_test
References: <1411499027-17801-1-git-send-email-pfeiner@google.com> <1411499123-18050-1-git-send-email-pfeiner@google.com> <1411499123-18050-2-git-send-email-pfeiner@google.com>
In-Reply-To: <1411499123-18050-2-git-send-email-pfeiner@google.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/23/2014 01:05 PM, Peter Feiner wrote:
> No arguments given after printf format string with "%s" conversion.
> 
> Signed-off-by: Peter Feiner <pfeiner@google.com>
> 
> ---

Please drop this one from the series. It is merged into linux-next
(in linux-kselfest fixes branch) queued for next merge window.

thanks,
-- Shuah


-- 
Shuah Khan
Sr. Linux Kernel Developer
Samsung Research America (Silicon Valley)
shuahkh@osg.samsung.com | (970) 217-8978
