Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751464AbaHQQsJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2014 12:48:09 -0400
Received: from linuxhacker.ru ([217.76.32.60]:56314 "EHLO fiona.linuxhacker.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750962AbaHQQsI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2014 12:48:08 -0400
Subject: Re: [PATCH 09/10] lustre: Add MAINTAINERS entry
Mime-Version: 1.0 (Apple Message framework v1283)
Content-Type: text/plain; charset=us-ascii
From: Oleg Drokin <green@linuxhacker.ru>
In-Reply-To: <20140817163739.GA15982@kroah.com>
Date: Sun, 17 Aug 2014 12:47:57 -0400
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Content-Transfer-Encoding: 8BIT
Message-Id: <980AF87D-E1F4-4C0E-AFF3-DB170DB98ADA@linuxhacker.ru>
References: <1408121295-29115-1-git-send-email-green@linuxhacker.ru> <1408121295-29115-10-git-send-email-green@linuxhacker.ru> <20140817163739.GA15982@kroah.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
X-Mailer: Apple Mail (2.1283)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Aug 17, 2014, at 12:37 PM, Greg Kroah-Hartman wrote:

> On Fri, Aug 15, 2014 at 12:48:14PM -0400, Oleg Drokin wrote:
>> Just add the entry with some info.
>> 
>> Signed-off-by: Oleg Drokin <green@linuxhacker.ru>
>> ---
>> MAINTAINERS | 8 ++++++++
>> 1 file changed, 8 insertions(+)
>> 
>> diff --git a/MAINTAINERS b/MAINTAINERS
>> index 7e2eb4c..369183b 100644
>> --- a/MAINTAINERS
>> +++ b/MAINTAINERS
>> @@ -8646,6 +8646,14 @@ W:	http://www.lirc.org/
>> S:	Odd Fixes
>> F:	drivers/staging/media/lirc/
>> 
>> +STAGING - LUSTRE PARALLEL FILESYSTEM
>> +M:	Oleg Drokin <oleg.drokin@intel.com>
>> +M:	Andreas Dilger <andreas.dilger@intel.com>
>> +L:	HPDD-discuss@lists.01.org (moderated for non-subscribers)
> 
> I _really_ hate moderated mailing lists for kernel development stuff.
> Why not just use the driverdev mailing list instead?

I guess this could be done if we really need to, but ...

> I note that you didn't even cc: this patch series to that list...

The instructions in the beginning of the file say:
"L: Mailing list that is relevant to this area"
This is the mailing list that is relevant to the area, but we don't really send patches in there,
and because it's premoderated it's not really convenient anyway as you rightly notice.
People can ask other questions they might have bout their problems there, though, and there's
a higher chance that somebody familiar with lustre will read and answer them.

the 'M:' is the send patches to according to the instructions?

The patches are CCed to linux-kernel by most everybody anyway, so do we really need to
spell this out explicitly with an 'L:' line or in some other way?