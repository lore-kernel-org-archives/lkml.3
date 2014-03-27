Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756389AbaC0QaO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 12:30:14 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:48598 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754638AbaC0QaM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 12:30:12 -0400
Message-ID: <5334520D.8060602@hurleysoftware.com>
Date: Thu, 27 Mar 2014 12:30:05 -0400
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Sasha Levin <sasha.levin@oracle.com>
CC: Greg KH <greg@kroah.com>, jslaby@suse.cz, Dave Jones <davej@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: tty: hang on ldisc_sem
References: <53344CE4.4070609@oracle.com>
In-Reply-To: <53344CE4.4070609@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sasha,

On 03/27/2014 12:08 PM, Sasha Levin wrote:
>
> Hi all,
>
> While fuzzing with trinity inside a KVM tools guest running latest -next
> kernel, I've encountered a lockup on ldisc_sem.

Can you send me the whole system log, preferably with the sysrq
show-task-states and held locks output in it (attachment is fine)?

Regards,
Peter Hurley
