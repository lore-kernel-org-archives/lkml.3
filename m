Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755317Ab3JXPP6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 11:15:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5242 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753324Ab3JXPP5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 11:15:57 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC] A logger specialized for receiving from netconsole.
References: <201310250002.FJI86420.FQHSLFOOOtMJVF@I-love.SAKURA.ne.jp>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Thu, 24 Oct 2013 11:15:53 -0400
In-Reply-To: <201310250002.FJI86420.FQHSLFOOOtMJVF@I-love.SAKURA.ne.jp>
	(Tetsuo Handa's message of "Fri, 25 Oct 2013 00:02:20 +0900")
Message-ID: <x49k3h2n1hy.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp> writes:

> Background:
>
>   When troubleshooting system freeze problems, obtaining SysRq messages
>   is commonly used. However, sometimes it is impossible to let syslog
>   daemon save the messages. In that case, serial console can be used.
>
>   However, in already-deployed enterprise servers, it is difficult to
>   reboot the system in order to add the serial console to the list of
>   consoles. Also, speak of virtualized servers in the cloud environment,
>   it may be difficult to add the virtual serial console which would
>   require FTP-like access to the log files saved on the virtualization
>   host.
>
>   As I'm working at NTT Open Source Software Center, I'm having
>   difficulties with obtaining SysRq messages from already-deployed
>   RHEL 3/4/5/6 servers where the serial console is not attached yet.

For rhel 3 and 4, you can actually configure netconsole to send syslog
style messages.  Red Hat shipped a userspace package named
netdump-server, which will create a directory per IP, and log netconsole
messages there.  The netdump-0.7.16 source rpm is the latest version I
could find, let me know if you want me to put the sources somewhere for
you.

Cheers,
Jeff
