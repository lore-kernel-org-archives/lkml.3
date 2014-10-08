Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755990AbaJHKfA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 06:35:00 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:65275 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755726AbaJHKe7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 06:34:59 -0400
Message-ID: <5435134E.1080802@nod.at>
Date: Wed, 08 Oct 2014 12:34:54 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Chen Hanxiao <chenhanxiao@cn.fujitsu.com>,
        containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
CC: Serge Hallyn <serge.hallyn@ubuntu.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Oleg Nesterov <oleg@redhat.com>, David Howells <dhowells@redhat.com>,
        Richard Weinberger <richard.weinberger@gmail.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Vasiliy Kulikov <segooon@gmail.com>, Mateusz Guzik <mguzik@redhat.com>
Subject: Re: [PATCHv4] procfs: show hierarchy of pid namespace
References: <1412762198-21825-1-git-send-email-chenhanxiao@cn.fujitsu.com>
In-Reply-To: <1412762198-21825-1-git-send-email-chenhanxiao@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 08.10.2014 11:56, schrieb Chen Hanxiao:
> This patch will show the hierarchy of pid namespace
> by /proc/pidns_hierarchy like:
> 
> [root@localhost ~]#cat /proc/pidns_hierarchy
> /proc/18060/ns/pid /proc/18102/ns/pid /proc/1534/ns/pid
> /proc/18060/ns/pid /proc/18102/ns/pid /proc/1600/ns/pid
> /proc/1550/ns/pid

A proc file that prints paths of other proc files, srsly? ;)
I didn't follow the whole discussion but why is this not
a directory containing symbolic links to other pid files in /proc/<PID>/ns/pid?

Thanks,
//richard
