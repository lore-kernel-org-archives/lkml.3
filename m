Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755399AbaDTS15 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2014 14:27:57 -0400
Received: from mail-ob0-f176.google.com ([209.85.214.176]:36704 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751236AbaDTS1z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2014 14:27:55 -0400
Message-ID: <535411A8.7040401@lwfinger.net>
Date: Sun, 20 Apr 2014 13:27:52 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Tony Luck <tony.luck@intel.com>, Gong Chen <gong.chen@intel.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: Bug in 3.15-rc1: Scheduling while atomic splats filling log -
 bisected to commit 27f6c57
References: <53502886.6020107@lwfinger.net>	<53535D1C.200@lwfinger.net> <CA+55aFxsDvc=3j9TFgEV7W7f-PMRn2UfqStHPXDVqCRXyPXzEg@mail.gmail.com>
In-Reply-To: <CA+55aFxsDvc=3j9TFgEV7W7f-PMRn2UfqStHPXDVqCRXyPXzEg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/20/2014 12:45 AM, Linus Torvalds wrote:
> Should be fixed in current git by commit ea431643d6c.

Yes, that commit did fix my issue.

Thanks,

Larry



