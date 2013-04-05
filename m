Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162847Ab3DEWBJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 18:01:09 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:45012 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162601Ab3DEWBH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 18:01:07 -0400
Date: Fri, 5 Apr 2013 15:01:05 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: "Puff ." <puff65537@bansheeslibrary.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC] drivers/staging/silicom/bp_proc.c removal
Message-ID: <20130405220105.GB31680@kroah.com>
References: <20130404191245.GT21522@ZenIV.linux.org.uk>
 <CAN4nR9cuvPgNK++N2=Mz3sifeuBfRtKdAEQ8m6MhcSvQVKn-Sg@mail.gmail.com>
 <20130405174802.GF4068@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130405174802.GF4068@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 05, 2013 at 06:48:02PM +0100, Al Viro wrote:
> On Fri, Apr 05, 2013 at 10:31:56AM -0700, Puff . wrote:
> > No reason not to.
> 
> Done (in vfs.git#for-next, should propagate in a few)

Thanks for doing that, you beat me to it.

greg k-h
