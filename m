Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753069AbaB1WTE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 17:19:04 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:51951 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752130AbaB1WTC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 17:19:02 -0500
Date: Fri, 28 Feb 2014 14:20:40 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Kumar Amit Mehta <gmate.amit@gmail.com>
Cc: devel@driverdev.osuosl.org, lisa@xenapiadmin.com, lidza.louina@gmail.com,
        kernel-janitors@vger.kernel.org, josh@joshtriplett.org,
        linux-kernel@vger.kernel.org, rashika.kheria@gmail.com,
        dan.carpenter@oracle.com
Subject: Re: [PATCH] staging: sb105x: b_pci_mp.c: fix for non-member access
Message-ID: <20140228222040.GA27989@kroah.com>
References: <1393554063-25823-1-git-send-email-gmate.amit@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1393554063-25823-1-git-send-email-gmate.amit@gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 28, 2014 at 04:21:03AM +0200, Kumar Amit Mehta wrote:
> 'struct tty_struct’ has no member named ‘low_latency’

This driver is marked BROKEN, and can't even compile, how did you test
this patch?

