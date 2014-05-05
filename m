Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754144AbaEECUE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2014 22:20:04 -0400
Received: from ozlabs.org ([103.22.144.67]:59468 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754025AbaEECUC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2014 22:20:02 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Bruno =?utf-8?Q?Pr=C3=A9mont?= <bonbons@linux-vserver.org>
Cc: linux-kernel@vger.kernel.org, Jiri Kosina <jkosina@suse.cz>
Subject: Re: [PATCH 7/9] drivers/hid/hid-picolcd_fb: avoid world-writable sysfs files.
In-Reply-To: <20140502214354.67061986@neptune.home>
References: <1398137612-9714-1-git-send-email-rusty@rustcorp.com.au> <1398137612-9714-8-git-send-email-rusty@rustcorp.com.au> <20140502214354.67061986@neptune.home>
User-Agent: Notmuch/0.17 (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Mon, 05 May 2014 11:27:47 +0930
Message-ID: <874n15c7hg.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bruno Prémont <bonbons@linux-vserver.org> writes:
> On Tue, 22 April 2014 Rusty Russell <rusty@rustcorp.com.au> wrote:
>> In line with practice for module parameters, we're adding a build-time
>> check that sysfs files aren't world-writable.
>> 
>> Cc: Bruno Prémont <bonbons@linux-vserver.org>
>> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
>
> Fine with me,
>   Acked-by: Bruno Prémont <bonbons@linux-vserver.org>
>
> Not sure which tree you plan to push this through, CCing Jiri
> as all picoLCD driver went in via HID tree.

Currently plan is that they'll go through my modules-next tree (which
is where this patch originated).

Thanks,
Rusty.
