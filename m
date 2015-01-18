Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751589AbbARAab (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2015 19:30:31 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:56453 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750953AbbARAaa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2015 19:30:30 -0500
Date: Sat, 17 Jan 2015 16:18:22 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Guillaume Vercoutere <gvercoutere@gmail.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] staging: android: Correct NULL comparison style in
 logger.c
Message-ID: <20150118001822.GA24046@kroah.com>
References: <1420467923-6397-1-git-send-email-gvercoutere@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1420467923-6397-1-git-send-email-gvercoutere@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 05, 2015 at 03:25:23PM +0100, Guillaume Vercoutere wrote:
> Replace explicit NULL comparison with !

Not a good idea, you just lost typechecking :(

