Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756501Ab3EGXTi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 19:19:38 -0400
Received: from mail-pb0-f43.google.com ([209.85.160.43]:40592 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753715Ab3EGXTf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 19:19:35 -0400
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Kevin Cernekee <cernekee@gmail.com>, linux-input@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Lenovo Yoga 13 touchpad regression
Date: Tue, 07 May 2013 16:19:31 -0700
Message-ID: <3470196.LXVkxnnbGR@dtor-d630.eng.vmware.com>
User-Agent: KMail/4.10.2 (Linux/3.8.11-200.fc18.x86_64; KDE/4.10.2; x86_64; ; )
In-Reply-To: <51898810.4090301@zytor.com>
References: <5188905A.4020703@zytor.com> <51894B6F.9040108@zytor.com> <51898810.4090301@zytor.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, May 07, 2013 04:02:40 PM H. Peter Anvin wrote:
> On 05/07/2013 11:43 AM, H. Peter Anvin wrote:
> > What is really bizarre is that some time today the touchpad
> > spontaneously started to work.  However, after a reboot it no longer
> > worked again.  This is on 3.8.11.  The keycode spewage continued, however.
> 
> OK, "spontaneously" seems to mean "after going in and out of suspend to
> RAM".

Does i8042.reset help by any chance?

-- 
Dmitry
