Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752856AbaBLQLP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 11:11:15 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:49798 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751735AbaBLQLN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 11:11:13 -0500
Date: Wed, 12 Feb 2014 08:13:22 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Tomas Winkler <tomas.winkler@intel.com>
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org, "chao.bi" <chao.bi@intel.com>,
        stable <stable@vger.kernel.org>
Subject: Re: [char-misc] mei: set client's read_cb to NULL when flow control
 fails
Message-ID: <20140212161322.GB22431@kroah.com>
References: <1392218828-23208-1-git-send-email-tomas.winkler@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392218828-23208-1-git-send-email-tomas.winkler@intel.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 12, 2014 at 05:27:08PM +0200, Tomas Winkler wrote:
> From: "chao.bi" <chao.bi@intel.com>

This doesn't match the Signed-off-by: line later in the patch :(

Please fix up.

greg k-h
