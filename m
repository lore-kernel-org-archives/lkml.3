Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752821AbbAYK53 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 05:57:29 -0500
Received: from h1446028.stratoserver.net ([85.214.92.142]:43325 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751535AbbAYK52 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 05:57:28 -0500
Message-ID: <54C4CC05.9090602@ahsoftware.de>
Date: Sun, 25 Jan 2015 11:57:09 +0100
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: =?UTF-8?B?UMOhZHJhaWcgQnJhZHk=?= <P@draigBrady.com>,
        linux-kernel@vger.kernel.org
CC: linux-kbuild@vger.kernel.org, Michal Marek <mmarek@suse.cz>,
        David Howells <dhowells@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH v2] modsign: use shred to overwrite the private key before
 deleting it
References: <54C2F4F8.20809@draigBrady.com> <1422096327-4483-1-git-send-email-holler@ahsoftware.de> <54C383E0.9060408@ahsoftware.de> <54C38B6D.1060806@ahsoftware.de> <54C3901D.8040406@ahsoftware.de> <54C45153.2050703@draigBrady.com> <54C4583A.5040505@ahsoftware.de> <54C4C65A.2020403@ahsoftware.de>
In-Reply-To: <54C4C65A.2020403@ahsoftware.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 25.01.2015 um 11:32 schrieb Alexander Holler:

> So we are now at the point that the only way to keep some information
> private (forever) is to not store it on any computer.

That should be written "any electronic device (including phones, 
tablets, cameras, TVs and clouds)" instead of "any computer".

>
> How crazy or userfriendly is that?
>
> Regards,
>
> Alexander Holler
>
>

