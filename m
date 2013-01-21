Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752902Ab3AVB3s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 20:29:48 -0500
Received: from ozlabs.org ([203.10.76.45]:58667 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751569Ab3AVB3r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 20:29:47 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Greg KH <gregkh@linuxfoundation.org>, Prarit Bhargava <prarit@redhat.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org
Subject: Re: module: put modules in list much earlier.
In-Reply-To: <20130121201221.GA8149@kroah.com>
References: <20130121014613.CF6ED660735@gitolite.kernel.org> <20130121201221.GA8149@kroah.com>
User-Agent: Notmuch/0.14 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Tue, 22 Jan 2013 08:46:25 +1030
Message-ID: <87mww2uqpy.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH <gregkh@linuxfoundation.org> writes:
> Rusty, should the commit below be applied to the 3.7-stable kernel tree?
>
> thanks,
>
> greg k-h

Good point. looks like commit which caused this (e9bda3b) went in 3.6
so I think you'll want the following:

0d21b0e3477395e7ff2acc269f15df6e6a8d356d module: add new state MODULE_STATE_UNFORMED
1fb9341ac34825aa40354e74d9a2c69df7d2c304 module: put modules in list much earlier.
ee61abb3223e28a1a14a8429c0319755d20d3e40 module: fix missing module_mutex unlock

Thanks,
Rusty.
