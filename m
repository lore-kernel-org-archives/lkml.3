Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753205AbbAXLhW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2015 06:37:22 -0500
Received: from h1446028.stratoserver.net ([85.214.92.142]:58411 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752059AbbAXLhU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2015 06:37:20 -0500
Message-ID: <54C383E0.9060408@ahsoftware.de>
Date: Sat, 24 Jan 2015 12:37:04 +0100
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: linux-kbuild@vger.kernel.org, Michal Marek <mmarek@suse.cz>,
        David Howells <dhowells@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH v2] modsign: use shred to overwrite the private key before
 deleting it
References: <54C2F4F8.20809@draigBrady.com> <1422096327-4483-1-git-send-email-holler@ahsoftware.de>
In-Reply-To: <1422096327-4483-1-git-send-email-holler@ahsoftware.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 24.01.2015 um 11:45 schrieb Alexander Holler:

> It uses shred, in the hope it will somedays learn how to shred stuff on
> FLASH based devices securely too, once that has become possible.

BTW: This is a good example where technology failed to keep the needs of 
users in mind.

It should be relatively easy to make that possible: Using secure trim 
which erases blocks instead of just marking them as free, it should be 
possible without much effort for file systems to implement a secure 
unlink. An obvious name would be sunlink(2). Or does such already exist? 
I've seen secure trim already exists for some devices, but not sunlink().

Regards,

Alexander Holler
