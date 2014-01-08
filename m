Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932369AbaAHXtB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 18:49:01 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:43950 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932219AbaAHXs6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 18:48:58 -0500
Date: Wed, 8 Jan 2014 15:49:28 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Oren Laadan <orenl@cellrox.com>
Cc: Linux Containers <containers@lists.linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        lxc-devel <lxc-devel@lists.sourceforge.net>,
        Serge Hallyn <serge@hallyn.com>,
        Eric Biederman <ebiederm@xmission.com>,
        Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
        Amir Goldstein <amir@cellrox.com>
Subject: Re: [PATCH 2/2] binder: implement namepsace support for Android
 binder driver
Message-ID: <20140108234928.GA20259@kroah.com>
References: <cover.1387706794.git.orenl@cellrox.com>
 <45c5d62a35f19228a681f5be9834741baabfdb0d.1387706794.git.orenl@cellrox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45c5d62a35f19228a681f5be9834741baabfdb0d.1387706794.git.orenl@cellrox.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 22, 2013 at 05:07:40AM -0500, Oren Laadan wrote:
> Add namespaces support for the Android binder driver.
> As binder is an IPC mechanism, tie its namespace to IPC_NS.

Why does binder need namespace support?

Does the Android userspace code support this?

I need an ack from the Android developers before I can take this.

Same goes for the ipc core changes, I need an ack from the maintainer of
that code before I can take it as well.

thanks,

greg k-h
