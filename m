Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753011AbaDOQ5z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 12:57:55 -0400
Received: from cantor2.suse.de ([195.135.220.15]:59466 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750932AbaDOQ5y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 12:57:54 -0400
Message-ID: <534D6510.3070509@suse.cz>
Date: Tue, 15 Apr 2014 18:57:52 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Christoph Lameter <cl@linux.com>
CC: Vince Weaver <vincent.weaver@maine.edu>, linux-kernel@vger.kernel.org,
        Jason Cooper <jason@lakedaemon.net>,
        Grant Likely <grant.likely@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        Rob Herring <robh+dt@kernel.org>
Subject: Re: [bisected] broken make-kpkg kernel build in 3.15-rc1
References: <alpine.DEB.2.10.1404150940250.14106@vincent-weaver-1.um.maine.edu> <534D4A59.6080401@suse.cz> <alpine.DEB.2.10.1404151146530.26562@gentwo.org>
In-Reply-To: <alpine.DEB.2.10.1404151146530.26562@gentwo.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-04-15 18:49, Christoph Lameter wrote:
> On Tue, 15 Apr 2014, Michal Marek wrote:
> 
>> I fail to see how the above commit is responsible for this. make install
>> starts /sbin/installkernel and the rest is the job of this script. To
>> me, it looks more like a fakeroot failure than a bug in make install.
> 
> The problem is that the kernel build process should not write to anything
> in the /etc/apt directory.

Again: make install starts /sbin/installkernel and the rest is the job
of this script. Which means you need to debug Debian's
/sbin/installkernel why it suddenly wants to modify files in /etc/apt.

Michal
