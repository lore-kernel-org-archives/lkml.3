Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934405AbaJ2QJ0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 12:09:26 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45365 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933452AbaJ2QJY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 12:09:24 -0400
Date: Thu, 30 Oct 2014 00:08:12 +0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Tristan Lelong <tristan.lelong@blunderer.org>
Cc: waydi1@gmail.com, dan.carpenter@oracle.com, viro@zeniv.linux.org.uk,
        gerb.stralko@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: android: logger: Remove uneeded tabs in
 variable declaration
Message-ID: <20141029160812.GA18229@kroah.com>
References: <1414562950-6555-1-git-send-email-tristan.lelong@blunderer.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1414562950-6555-1-git-send-email-tristan.lelong@blunderer.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 28, 2014 at 11:09:10PM -0700, Tristan Lelong wrote:
> This patch removes tabs used to align variable names in declaration and assignation.
> It replaces them with exactly one space.

Why?  This seems like a totally unneeded change, sorry.

greg k-h
