Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932148AbaLVVSE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 16:18:04 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:37434 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754900AbaLVVSC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 16:18:02 -0500
Date: Mon, 22 Dec 2014 13:18:01 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: samuel kihahu <skihahu@gmail.com>
Cc: devel@driverdev.osuosl.org, HPDD-discuss@ml01.01.org,
        andreas.dilger@intel.com, linux-kernel@vger.kernel.org,
        oleg.drokin@intel.com
Subject: Re: [PATCH] staging: lustre: cleanup align switch and case
Message-ID: <20141222211801.GA29847@kroah.com>
References: <1419281337-4076-1-git-send-email-skihahu@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1419281337-4076-1-git-send-email-skihahu@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 22, 2014 at 11:48:57PM +0300, samuel kihahu wrote:
> From: skihahu <skihahu@gmail.com>
> 
> Align switch and case to be at the same indent.
> 
> Signed-off-by: samuel kihahu <skihahu@gmail.com>

The "From:" and "Signed-off-by:" names don't match, which doesn't make
much sense, right?  Please fix and resend.

