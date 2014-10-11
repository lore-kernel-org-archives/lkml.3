Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752439AbaJKT1t (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2014 15:27:49 -0400
Received: from relay1.mentorg.com ([192.94.38.131]:36055 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751075AbaJKT1r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2014 15:27:47 -0400
Message-ID: <543984A8.8050701@mentor.com>
Date: Sat, 11 Oct 2014 14:27:36 -0500
From: Nathan Lynch <Nathan_Lynch@mentor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Rik van Riel <riel@redhat.com>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>,
        Linux USB Mailing List <linux-usb@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>, <josh@joshtriplett.org>,
        Rabin Vincent <rabin@rab.in>, Alan Stern <stern@rowland.harvard.edu>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Sasha Levin <sasha.levin@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: RCU bug with v3.17-rc3 ?
References: <20140905213216.GD5001@linux.vnet.ibm.com> <20141008171322.GH22688@saruman> <20141008175707.GI22688@saruman> <20141008212938.GP22688@saruman> <20141009160138.GA2396@cmpxchg.org> <20141009162656.GE16002@saruman> <20141009204101.GA25955@debian> <20141009204637.GE25729@saruman> <20141009210715.GH25729@saruman> <20141010135743.GB31348@saruman> <20141010162531.GL12379@n2100.arm.linux.org.uk> <54388B81.5020306@mentor.com>
In-Reply-To: <54388B81.5020306@mentor.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/10/2014 08:44 PM, Nathan Lynch wrote:
> On 10/10/2014 11:25 AM, Russell King - ARM Linux wrote:
>>
>> Right, so GCC 4.8.{1,2} are totally unsuitable for kernel building (and
>> it seems that this has been known about for some time.)
> 
> Looking at http://gcc.gnu.org/PR58854 it seems that all 4.8.x for x < 3
> are affected, as well as 4.9.0.

Correction -- 4.9.0 has this fixed, even though the GCC PR shows it as a
"known to fail" version.

