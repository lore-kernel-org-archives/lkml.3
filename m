Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753721AbaKUGEN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 01:04:13 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:50875 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751207AbaKUGEM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 01:04:12 -0500
Date: Thu, 20 Nov 2014 22:02:52 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: arnd@arndb.de, ebiederm@xmission.com, gnomes@lxorguk.ukuu.org.uk,
        teg@jklm.no, jkosina@suse.cz, luto@amacapital.net,
        linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: daniel@zonque.org, dh.herrmann@gmail.com, tixxdz@opendz.org
Subject: Re: [PATCH v2 00/13] Add kdbus implementation
Message-ID: <20141121060252.GA27160@kroah.com>
References: <1416546149-24799-1-git-send-email-gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1416546149-24799-1-git-send-email-gregkh@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 20, 2014 at 09:02:16PM -0800, Greg Kroah-Hartman wrote:
> kdbus is a kernel-level IPC implementation that aims for resemblance to
> the the protocol layer with the existing userspace D-Bus daemon while
> enabling some features that couldn't be implemented before in userspace.
> 
> The documentation in the first patch in this series explains the
> protocol and the API details.

Ugh, and I can't seem to remember to put the patch numbers on the
series, sorry about that, my git format-patch default options are set up
for applying patches and responding to them, not generating numbered
series :(

If someone wants the numbers, I can resend them, otherwise, just stick
with the git tree...

thanks,

greg k-h
