Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754585AbaIKShx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 14:37:53 -0400
Received: from mail-we0-f171.google.com ([74.125.82.171]:64459 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754199AbaIKSht (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 14:37:49 -0400
Message-ID: <5411EBF3.3040008@gmail.com>
Date: Thu, 11 Sep 2014 20:37:39 +0200
From: Piotr Karbowski <piotr.karbowski@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Mateusz Guzik <mguzik@redhat.com>, Al Viro <viro@ZenIV.linux.org.uk>
CC: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: /proc/<pid>/exe symlink behavior change in >=3.15.
References: <540B8040.5010206@gmail.com> <20140907075607.GA11240@mguzik>
In-Reply-To: <20140907075607.GA11240@mguzik>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mateusz,

 > I can implement that later if it sounds sane enough.
> Note this behaviour seems to be a requirement for cross-rename to work.
>
> At least restoring previous behaviour while keeping cross-rename is not hard,
> I can write it later.

Have you find a proper solution for this very issue or anything that can 
push forward addressing it?

Thankfully this issue has been addressed by a workaround in fs/dcache.c 
in grsecurity patch for 3.16.2 
(grsecurity-3.0-3.16.2-201409082129.patch) but it would be great to have 
a fix upstream.

-- Piotr.
