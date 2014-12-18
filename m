Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751927AbaLRQwj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 11:52:39 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:53119 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751877AbaLRQwi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 11:52:38 -0500
Date: Thu, 18 Dec 2014 08:52:36 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Robert Nachlinger <robert.nachlinger@gmail.com>
Cc: devel@driverdev.osuosl.org,
        Robert Nachlinger <robert.nachlinger@googlemail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: gdm724x: fix space before comma coding style
 issue in gdm_mux.c
Message-ID: <20141218165236.GA10294@kroah.com>
References: <1418921189-31372-1-git-send-email-robert.nachlinger@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1418921189-31372-1-git-send-email-robert.nachlinger@googlemail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 18, 2014 at 05:46:29PM +0100, Robert Nachlinger wrote:
> This is a patch to the gdm_mux.c file that fixes a space before comma coding style issue found by the checkpatch.pl tool.

Please line-wrap your changelog text, there's no reason to have lines
this long, right?


greg k-h
