Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757680AbaJ2XAZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 19:00:25 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54724 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757456AbaJ2XAX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 19:00:23 -0400
Date: Thu, 30 Oct 2014 00:00:16 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
cc: linux-api@vger.kernel.org, linux-kernel@vger.kernel.org,
        john.stultz@linaro.org, arnd@arndb.de, tj@kernel.org,
        marcel@holtmann.org, desrt@desrt.ca, hadess@hadess.net,
        dh.herrmann@gmail.com, tixxdz@opendz.org,
        simon.mcvittie@collabora.co.uk, daniel@zonque.org,
        alban.crequy@collabora.co.uk, javier.martinez@collabora.co.uk,
        teg@jklm.no
Subject: Re: [PATCH 00/12] Add kdbus implementation
In-Reply-To: <1414620056-6675-1-git-send-email-gregkh@linuxfoundation.org>
Message-ID: <alpine.LRH.2.00.1410292354480.11562@twin.jikos.cz>
References: <1414620056-6675-1-git-send-email-gregkh@linuxfoundation.org>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Oct 2014, Greg Kroah-Hartman wrote:

> kdbus is a kernel-level IPC implementation that aims for resemblance to
> the the protocol layer with the existing userspace D-Bus daemon while
> enabling some features that couldn't be implemented before in userspace.

I'd be interested in the features that can't be implemented in userspace 
(and therefore would justify existence of kdbus in the kernel). Could you 
please point me to such list / documentation?

It seems to me that most of the highlight features from the cover letter 
can be "easily" (for certain definition of that word, of course) 
implemented in userspace (vmsplice(), sending fd through unix socket, user 
namespaces, UUID management, etc).

Thanks,

-- 
Jiri Kosina
SUSE Labs

