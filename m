Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932968AbaGUP1C (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 11:27:02 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37691 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932367AbaGUP07 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 11:26:59 -0400
Date: Mon, 21 Jul 2014 08:26:35 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Kees Cook <keescook@chromium.org>
Cc: Ming Lei <ming.lei@canonical.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Luis R. Rodriguez" <mcgrof@suse.com>,
        James Morris <james.l.morris@oracle.com>,
        David Howells <dhowells@redhat.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        linux-security-module <linux-security-module@vger.kernel.org>,
        linux-firmware@kernel.org,
        linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 6/7] firmware_class: add "fd" input file
Message-ID: <20140721152635.GB6363@kroah.com>
References: <1405373897-31671-1-git-send-email-keescook@chromium.org>
 <1405373897-31671-7-git-send-email-keescook@chromium.org>
 <CACVXFVOnxjXjnKRWg7sv425POLSS96kAxxEohtLqj4dvcxnRyg@mail.gmail.com>
 <CAGXu5j+xx2exZdD64mXWzmvVUzBrFUOg-kZ5E4+tvKAuGTKW4w@mail.gmail.com>
 <CACVXFVMk5hTAvMgL0V2ycy-P=LCtOktimw5Hst+aFYLS6jewXw@mail.gmail.com>
 <CAGXu5jLD=9cqzV90JKEBJjwzTXVzGhz9_1nnwFCG_0zcA1TE8A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5jLD=9cqzV90JKEBJjwzTXVzGhz9_1nnwFCG_0zcA1TE8A@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 21, 2014 at 08:08:16AM -0700, Kees Cook wrote:
> Perhaps it would be easier if I also sent the patch to udev's helper,
> so you could see how I propose handling the userspace change to using
> the new interface?

As there is no more "udev firmware helper", I don't know what you would
be patching here.  Firmware should always be loaded by the kernel
directly, udev isn't involved anyore at all.

confused,

greg k-h
