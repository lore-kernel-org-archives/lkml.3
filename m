Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754897AbaDMNDL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2014 09:03:11 -0400
Received: from mail-ve0-f180.google.com ([209.85.128.180]:42105 "EHLO
	mail-ve0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754752AbaDMNDI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2014 09:03:08 -0400
MIME-Version: 1.0
In-Reply-To: <CAM1qvvhTaChkceBawnZZKZYT6tURcVZQe3upq3dpn_S9wp0C-Q@mail.gmail.com>
References: <CAM1qvvhTaChkceBawnZZKZYT6tURcVZQe3upq3dpn_S9wp0C-Q@mail.gmail.com>
Date: Sun, 13 Apr 2014 15:03:07 +0200
Message-ID: <CAM1qvvjXhz65PGEqfgyeaL4rGtZf_Kcn8T_QSw0BYGY0VHW9tQ@mail.gmail.com>
Subject: Re: [tip:x86/urgent] x86-64, modify_ldt: Ban 16-bit segments on
 64-bit kernels
From: Jan Janecek <janjanjanx@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-04-12 15:25, H. Peter Anvin:
> On 04/12/2014 02:53 PM, Linus Torvalds wrote:
>> On Sat, Apr 12, 2014 at 12:44 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>>> Run a 32-bit VM.  The 32-bit kernel does this right.
>>
>> I really don't think that's the answer.
>>
>> If people really run these 16-bit programs, we need to allow it.
>> Clearly it used to work.
>>
>> Just make the unconditional "don't allow 16-bit segments" be a sysconf
>> entry.
>>
>
> Well, is there more than one user, really... that's my question.
>

Just to let you know, I use this too for running some old Win16 apps,
so there's at least two of us... But doesn't this change also break
DPMI apps running in dosemu?
