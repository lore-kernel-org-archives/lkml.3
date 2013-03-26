Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759092Ab3CZBrh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 21:47:37 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:35747 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759016Ab3CZBrg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 21:47:36 -0400
Date: Mon, 25 Mar 2013 18:47:33 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: hjk@hansjkoch.de, linux-kernel@vger.kernel.org
Cc: Damian Hobson-Garcia <dhobsong@igel.co.jp>
Subject: Re: [PATCH] drivers: uio: Fix UIO device registration failure
Message-ID: <20130326014733.GA6496@kroah.com>
References: <1364261482-19160-1-git-send-email-dhobsong@igel.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1364261482-19160-1-git-send-email-dhobsong@igel.co.jp>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 26, 2013 at 10:31:22AM +0900, Damian Hobson-Garcia wrote:
> Until recently uio_get_minor() returned 0 for success and
> a negative value on failure.  This became non-negative for suceess and
> negative for failure.  Restore the original return value spec so that we can
> successfully initialize UIO devices with a non-zero minor device
> number.
> 
> Signed-off-by: Damian Hobson-Garcia <dhobsong@igel.co.jp>
> ---
>  drivers/uio/uio.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)

Hans, don't you have a bunch of uio patches queued up for me?  I've been
ignoring them, thinking you are collecting them, is this not true?

greg k-h
