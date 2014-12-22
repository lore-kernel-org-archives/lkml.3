Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752805AbaLVXu7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 18:50:59 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:38103 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751108AbaLVXu6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 18:50:58 -0500
Date: Mon, 22 Dec 2014 15:50:56 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Simone Weiss <simone.weiss@fau.de>
Cc: helene.gsaenger@studium.fau.de, linux-kernel@i4.cs.fau.de,
        lidza.louina@gmail.com, markh@compro.net,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dgnc/digi.h: checkpatch: Changend complex macros
 (enclosed parantheses)
Message-ID: <20141222235056.GA13403@kroah.com>
References: <1419211054-3052-5-git-send-email-simone.weiss@fau.de>
 <1419275042-12289-1-git-send-email-simone.weiss@fau.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1419275042-12289-1-git-send-email-simone.weiss@fau.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 22, 2014 at 08:04:02PM +0100, Simone Weiss wrote:
> The patch previous in this thread (dgnc/dpacompat.h) defines partly the same macros as dgnc/digi.h and so it  is neccessary tochange the macros in this file as well, so no macros get redefined
> 

Please wrap your changelog body text :(

> 
> 
> Signed-off-by: Simone Weiss <simone.weiss@fau.de>
> Signed-off-by: Helene Gsaenger <helene.gsaenger@studium.fau.de> 

Trailing whitespace :(

Please try again.

