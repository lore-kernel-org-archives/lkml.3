Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755826AbaFQPcb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 11:32:31 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55012 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755372AbaFQPc3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 11:32:29 -0400
Message-ID: <53A05F8A.6060108@suse.cz>
Date: Tue, 17 Jun 2014 17:32:26 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Randy Dunlap <rdunlap@infradead.org>, linux-kbuild@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
CC: linux-media <linux-media@vger.kernel.org>
Subject: Re: MANY errors while building media docbooks
References: <539F2926.4020004@infradead.org>
In-Reply-To: <539F2926.4020004@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-06-16 19:28, Randy Dunlap wrote:
> on Linux v3.16-rc1, building docbooks to a separate build directory
> (mkdir DOC; make O=DOC htmldocs) gives me more than 12,000 lines like this:
> 
> grep: ./Documentation/DocBook//vidioc-subdev-g-fmt.xml: No such file or directory
> grep: ./Documentation/DocBook//vidioc-subdev-g-frame-interval.xml: No such file or directory
> grep: ./Documentation/DocBook//vidioc-subdev-g-selection.xml: No such file or directory
> grep: ./Documentation/DocBook//vidioc-subscribe-event.xml: No such file or directory
> grep: ./Documentation/DocBook//media-ioc-device-info.xml: No such file or directory
> grep: ./Documentation/DocBook//media-ioc-enum-entities.xml: No such file or directory
> grep: ./Documentation/DocBook//media-ioc-enum-links.xml: No such file or directory
> grep: ./Documentation/DocBook//media-ioc-setup-link.xml: No such file or directory


Seems to be another fallout of the relative path patches, I'll have a look.

Thanks,
Michal

