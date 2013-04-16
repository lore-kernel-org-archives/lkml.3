Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754378Ab3DPGt5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 02:49:57 -0400
Received: from plane.gmane.org ([80.91.229.3]:38965 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752947Ab3DPGt4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 02:49:56 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: "lkml@tigusoft.pl" <lkml@tigusoft.pl>
Subject: Re: Very poor latency when using hard drive (raid1)
Date: Tue, 16 Apr 2013 08:49:33 +0200
Organization: tigusoft.pl
Message-ID: <kkis9q$g09$1@ger.gmane.org>
References: <kkgj31$jc6$1@ger.gmane.org>
Reply-To: lkml@tigusoft.pl
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: bolobolo2.torservers.net
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20121215 Icedove/3.0.11
In-Reply-To: <kkgj31$jc6$1@ger.gmane.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15/04/13 11:59, lkml@tigusoft.pl wrote:
> There are 2 hard drives (normal, magnetic) in software raid 1
> on 3.2.41 kernel.
> 
> When I write into them e.g. using dd from /dev/zero to a local file
> (ext4 on default settings), running 2 dd at once (writing two files) it
> starves all other programs that try to use the disk.
> 
> Running ls on any directory on same disk (same fs btw), takes over half
> minute to execute, same for any other disk touching action.
> 
> Did anyone seen such problem, where too look, what to test?
> 
> What could solve it (other then ionice on applications that I expect to
> use hard drive)?

I got reply (by e-mail) suggesting to use XFS.
Thanks, possible for other/next server.

But I fell this should work correctly as well on ext4.




