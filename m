Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753566AbaIOJNH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 05:13:07 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60342 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753252AbaIOJNF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 05:13:05 -0400
Message-ID: <5416AD96.7070306@suse.cz>
Date: Mon, 15 Sep 2014 11:12:54 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Kirill Tkhai <tkhai@yandex.ru>
CC: Greg KH <gregkh@linuxfoundation.org>, arnd@arndb.de,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        oleg@redhat.com, grant.likely@secretlab.ca, ebiederm@xmission.com,
        akpm@linux-foundation.org, ktkhai@parallels.com, sam@ravnborg.org
Subject: Re: [PATCH 0/3] Implement /proc/built-in file similar to /proc/modules
References: <20140914100545.3745.23394.stgit@localhost> <20140914153832.GC4064@kroah.com>
In-Reply-To: <20140914153832.GC4064@kroah.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-09-14 17:38, Greg KH wrote:
> On Sun, Sep 14, 2014 at 02:18:13PM +0400, Kirill Tkhai wrote:
>> This series implements a possibility to show the list of built-in drivers
>> to userspace. The names of drivers will be the same as when they are modules.
> 
> Have you looked at /sys/modules/ ?  Doesn't that show what you want
> here?

Plus, we have /lib/modules/.../modules.builtin, which is already
understood by kmod. And if you badly need to display the list in /proc,
then please just reuse the modules.builtin file.

Michal

