Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752121AbaJOXfk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 19:35:40 -0400
Received: from roy.gaast.net ([80.101.33.21]:37075 "EHLO mail.gaast.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751262AbaJOXf1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 19:35:27 -0400
Message-ID: <543F049F.5090605@gaast.net>
Date: Thu, 16 Oct 2014 00:34:55 +0100
From: Wilmer van der Gaast <wilmer@gaast.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130112 Icedove/17.0.2
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Pavel Machek <pavel@ucw.cz>,
        Rafael Wysocki <rafael.j.wysocki@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Machine crashes right *after* ~successful resume
References: <54347520.3050109@gaast.net> <543AA2FE.20105@gaast.net> <20141012204032.GA11171@amd> <9751497.0fL0kvsyX7@vostro.rjw.lan> <20141015111641.GC7792@gaast.net> <CAErSpo5A+nHTu2Y6KrXowBBCBsNw_hO0SRsnc6YRdJChCUmO6w@mail.gmail.com> <CAE9FiQV9t0bCfUy5Fichdk=04ruEVxGv-LUK1xxZjCrasAOACg@mail.gmail.com>
In-Reply-To: <CAE9FiQV9t0bCfUy5Fichdk=04ruEVxGv-LUK1xxZjCrasAOACg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Yinghai,

On 15-10-14 19:39, Yinghai Lu wrote:
>
> so third resume will not work? that is strange.
> second and third should not use same code path...
>
Always exactly the third time, yes. Seems strange indeed. :-( I was 
under the impression that on each resume, completion time of device 
resumes was growing, and wondered whether that could be related. However 
looking back at my logs, this is not consistent, in some cases the time 
is constant.

Anyway, your patch works! Had to tweak it slightly to apply cleanly to 
the 3.17 tarball I have, but my machine now went through eleven 
successful suspend+resume cycles again.

Is there anything I can do now to find out why your change is causing my 
machine to crash?

Thank you!


Wilmer v/d Gaast.

-- 
+-------- .''`.     - -- ---+  +        - -- --- ---- ----- ------+
| wilmer : :'  :  gaast.net |  | OSS Programmer   www.bitlbee.org |
| lintux `. `~'  debian.org |  | Full-time geek  wilmer.gaast.net |
+--- -- -  ` ---------------+  +------ ----- ---- --- -- -        +
