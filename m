Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751853AbbASCCN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2015 21:02:13 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:35843 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751404AbbASCCN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2015 21:02:13 -0500
Date: Mon, 19 Jan 2015 06:50:30 +0800
From: Greg KH <gregkh@linuxfoundation.org>
To: jitendra kumar khasdev <jkhasdev@gmail.com>
Cc: devel@driverdev.osuosl.org, abbotti@mev.co.uk,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7] Staging: comedi: patch to fix line over 80 characters
 warning
Message-ID: <20150118225030.GB2073@kroah.com>
References: <1420865403-4932-1-git-send-email-jkhasdev@gmail.com>
 <20150117223312.GA15083@kroah.com>
 <CAN-6CVnkeaVMOWjyx8N-R3uK4N48PficrCgSt7_0_NX0r3-5hg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAN-6CVnkeaVMOWjyx8N-R3uK4N48PficrCgSt7_0_NX0r3-5hg@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


A: No.
Q: Should I include quotations after my reply?

http://daringfireball.net/2007/07/on_top

On Sun, Jan 18, 2015 at 07:47:50PM +0530, jitendra kumar khasdev wrote:
> Will you give reason for not apply my patch on your tree. I have
> tested by appling on linux main tree.

Probably because someone else sent in fixes that changed things in this
area, and those patches are not in Linus's tree yet.  Please always work
against the linux-next tree, or even better, my staging.git tree, using
the staging-testing branch.

thanks,

greg k-h
