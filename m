Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753744AbaAUHaa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 02:30:30 -0500
Received: from mx1.redhat.com ([209.132.183.28]:17988 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750841AbaAUHaW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 02:30:22 -0500
Message-ID: <52DE2208.9040908@redhat.com>
Date: Tue, 21 Jan 2014 08:30:16 +0100
From: Florian Weimer <fweimer@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Andrew Ayer <agwa@andrewayer.name>,
        Alexander Viro <viro@zeniv.linux.org.uk>
CC: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] vfs: Add fchmodat4 syscall: fchmodat with flag argument
References: <1326419626-22568-1-git-send-email-agwa@andrewayer.name> <1326419626-22568-2-git-send-email-agwa@andrewayer.name>
In-Reply-To: <1326419626-22568-2-git-send-email-agwa@andrewayer.name>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/13/2012 02:53 AM, Andrew Ayer wrote:
> This adds a 4 argument version of fchmodat (fchmodat4) that
> supports a flag argument, as specified by POSIX.  It supports
> the same two flags as fchownat: AT_SYMLINK_NOFOLLOW and AT_EMPTY_PATH.

I don't think it's possible to emulate AT_EMPTY_PATH in user space, so I 
wonder if this could be applied, and if not, why.  Thanks.

-- 
Florian Weimer / Red Hat Product Security Team
