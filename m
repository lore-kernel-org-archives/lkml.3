Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754757AbaB0Da7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 22:30:59 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:55143 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753262AbaB0Da6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 22:30:58 -0500
Date: Wed, 26 Feb 2014 19:34:00 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: John Stultz <john.stultz@linaro.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Colin Cross <ccross@android.com>,
        Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
        Serban Constantinescu <serban.constantinescu@arm.com>,
        Android Kernel Team <kernel-team@android.com>
Subject: Re: [RFC][PATCH] staging: Fix build issues with new binder API
Message-ID: <20140227033400.GA31199@kroah.com>
References: <1393453747-12513-1-git-send-email-john.stultz@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1393453747-12513-1-git-send-email-john.stultz@linaro.org>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 26, 2014 at 02:29:07PM -0800, John Stultz wrote:
> The new 64bit binder API causes build issues on 32bit ARM
> due to the lack of 64bit __get_user_asm_* implementation.

So no one ever tested this out on ARM?  Really, that seems odd...

Anyway, if you want this to always be on, that's fine with me, your
choice :)
