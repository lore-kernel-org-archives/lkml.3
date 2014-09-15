Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753134AbaIOHVx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 03:21:53 -0400
Received: from ducie-dc1.codethink.co.uk ([185.25.241.215]:51999 "EHLO
	ducie-dc1.codethink.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751055AbaIOHVw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 03:21:52 -0400
Message-ID: <54169389.6060608@codethink.co.uk>
Date: Mon, 15 Sep 2014 08:21:45 +0100
From: Rob Jones <rob.jones@codethink.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.7.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, linux-kernel@codethink.co.uk
Subject: Re: [PATCH 0/2] fs: proc: use seq_open_private()
References: <1410530978-29627-1-git-send-email-rob.jones@codethink.co.uk> <20140912145019.9e1665011c2d2e9bcb55f0c1@linux-foundation.org>
In-Reply-To: <20140912145019.9e1665011c2d2e9bcb55f0c1@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 12/09/14 22:50, Andrew Morton wrote:
> On Fri, 12 Sep 2014 15:09:36 +0100 Rob Jones <rob.jones@codethink.co.uk> wrote:
>
>>    fs: proc: use __seq_open_private()
>>    fs: proc: use __seq_open_private()
>
> See the problem?  We have two different patches, both named the same.

Always another gotcha! :-)

Seriously, does it say anywhere that patch names have to be unique? It
makes perfect sense when it's pointed out but it never occurred to me.

I'll make sure I don't do it again.

>
> I renamed them to
>
> 	fs/proc/task_nommu.c: use __seq_open_private()
> 	fs/proc/task_mmu.c: use __seq_open_private()

Thank you, much appreciated. I would have been happy to re-submit.

>
> I really don't understand this practice of replacing "/" with ": " in
> patch titles.  Why not just use the "/"?

I'll do this in future too.

Sigh. So much to learn.

-- 
Rob Jones
Codethink Ltd
mailto:rob.jones@codethink.co.uk
tel:+44 161 236 5575
